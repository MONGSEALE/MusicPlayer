//
//  YoutubePlayViewModel.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/8/25.
//

import Foundation
import YouTubeKit
import AVKit
import RealmSwift

class YoutubePlayViewModel : ObservableObject {
    
    @Published var player: AVPlayer? = nil {
          didSet {
              // player가 변경되면 기존 관찰을 취소하고 새로 설정
              timeControlStatusObservation?.invalidate()
              if let player = player {
                  observePlayerStatus(for: player)
              }
          }
      }
    @Published var isButtonEnabled : Bool = false
    @Published var showSuccessToastMessage : Bool = false
    @Published var showErrorToastMessage : Bool = false
    @Published var isPlaying : Bool = true
    static private var playerItemCache: [String: AVPlayerItem] = [:]
    private var extractedVideo : AVPlayerItem? = nil
    
    private var timeControlStatusObservation: NSKeyValueObservation?
     
     private func observePlayerStatus(for player: AVPlayer) {
         // AVPlayer의 timeControlStatus를 관찰하여 isPlaying을 업데이트
         timeControlStatusObservation = player.observe(\.timeControlStatus, options: [.new, .initial]) { [weak self] player, change in
             DispatchQueue.main.async {
                 self?.isPlaying = (player.timeControlStatus == .playing)
             }
         }
     }
    
    func extractVideo(videoID: String) async {
        await MainActor.run{
            self.isButtonEnabled = false
        }
          do {
              //YoutubeKit을 이용하여 videoID를 이용하여 stream을 불러오기
              let streams = try await YouTube(videoID: videoID, methods: [.local, .remote]).streams

              if Task.isCancelled { return }
              
              // 1. progressive 스트림 먼저 시도
              if let progressiveStream = streams.filterVideoAndAudio().filter(byResolution: { $0! <= 1080 }).highestResolutionStream() {
                  let playerItem = AVPlayerItem(url: progressiveStream.url)
                  await MainActor.run {
                      self.player = AVPlayer(playerItem: playerItem)
                      self.extractedVideo = playerItem
                      self.isButtonEnabled = true
                  }
                  return
              }
              // 2. progressive 스트림이 없으면, adaptive 스트림으로 처리
              guard let videoOnlyStream = streams.filterVideoOnly().filter(byResolution: { $0! <= 1080 }).highestResolutionStream(),
                    let audioOnlyStream = streams.filterAudioOnly().highestAudioBitrateStream()
              else {
                  print("적절한 스트림을 찾지 못했습니다.")
                  return
              }
              let videoURL = videoOnlyStream.url
              let audioURL = audioOnlyStream.url

              // AVURLAsset을 생성하고 필요한 키를 비동기적으로 로드
              let videoAsset = AVURLAsset(url: videoURL)
              let audioAsset = AVURLAsset(url: audioURL)
              try await withThrowingTaskGroup(of: Void.self) { innerGroup in
                  innerGroup.addTask {
                      _ = try await videoAsset.load(.tracks)
                      _ = try await videoAsset.load(.preferredTransform)
                  }
                  innerGroup.addTask {
                      _ = try await audioAsset.load(.tracks)
                      // audioAsset에는 .preferredTransform이 필요하지 않을 수 있음.
                  }
                  try await innerGroup.waitForAll()
              }
              
              if Task.isCancelled { return }
              
              let mixComposition = AVMutableComposition()
              guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                                                preferredTrackID: kCMPersistentTrackID_Invalid),
                    let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
              else {
                  print("트랙 추가 실패")
                  return
              }
              
              guard let videoTrack = try await videoAsset.loadTracks(withMediaType: .video).first,
                    let audioTrack = try await audioAsset.loadTracks(withMediaType: .audio).first
                        
              else {
                  print("원본 트랙 불러오기 실패")
                  return
              }
              
              do{
                  let videoDuration = try await videoAsset.load(.duration)
                    let audioDuration = try await audioAsset.load(.duration)
                  
                     // 각각의 재생시간을 절반으로 계산.
                     let halfVideoDuration = CMTimeMultiplyByFloat64(videoDuration, multiplier: 0.5)
                     let halfAudioDuration = CMTimeMultiplyByFloat64(audioDuration, multiplier: 0.5)
                     
                     let videoTimeRange = CMTimeRange(start: .zero, duration: halfVideoDuration)
                     let audioTimeRange = CMTimeRange(start: .zero, duration: halfAudioDuration)
                  do {
                      try compositionVideoTrack.insertTimeRange(videoTimeRange, of: videoTrack, at: .zero)
                      try compositionAudioTrack.insertTimeRange(audioTimeRange, of: audioTrack, at: .zero)
                  } catch {
                      print("스트림 결합 실패: \(error)")
                      return
                  }
              }
              catch{
                  print("지속시간 로드 실패: \(error)")
                    return
              }

              if Task.isCancelled { return }
              
              let playerItem = AVPlayerItem(asset: mixComposition)
              await MainActor.run {
                  self.player = AVPlayer(playerItem: playerItem)
                  self.extractedVideo = playerItem
                  self.isButtonEnabled = true
              }
          } catch {
              print("에러 발생: \(error)")
          }
      }

    
    func extractAndStoreVideos(videoIDs: [String]) async {
           await withTaskGroup(of: Void.self) { group in
               for videoID in videoIDs {
                   // 이미 캐시에 있으면 건너뜀
                   if YoutubePlayViewModel.playerItemCache[videoID] != nil { continue }
                
                   group.addTask {
                       do {
                           // YouTubeKit을 이용하여 스트림 추출
                           let streams = try await YouTube(videoID: videoID, methods: [.local, .remote]).streams
                           
                           // 1. progressive 스트림 먼저 시도
                           if let progressiveStream = streams.filterVideoAndAudio().filter(byResolution: { $0! <= 1080 }).highestResolutionStream() {
                               let playerItem = AVPlayerItem(url: progressiveStream.url)
                               await MainActor.run {
                                   YoutubePlayViewModel.playerItemCache[videoID] = playerItem
                               }
                               return
                           }
                           
                           // 2. progressive 스트림이 없으면 adaptive 스트림 처리
                           guard let videoOnlyStream = streams.filterVideoOnly().filter(byResolution: { $0! <= 1080 }).highestResolutionStream(),
                                 let audioOnlyStream = streams.filterAudioOnly().highestAudioBitrateStream()
                           else {
                               print("적절한 스트림을 찾지 못했습니다 for \(videoID)")
                               return
                           }
                           let videoURL = videoOnlyStream.url
                           let audioURL = audioOnlyStream.url
                           
                           // AVURLAsset 생성 및 비동기 키 로드
                           let videoAsset = AVURLAsset(url: videoURL)
                           let audioAsset = AVURLAsset(url: audioURL)
                           try await withThrowingTaskGroup(of: Void.self) { innerGroup in
                               innerGroup.addTask {
                                   _ = try await videoAsset.load(.tracks)
                                   _ = try await videoAsset.load(.preferredTransform)
                               }
                               innerGroup.addTask {
                                   _ = try await audioAsset.load(.tracks)
                               }
                               try await innerGroup.waitForAll()
                           }
                           
                           let mixComposition = AVMutableComposition()
                           guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                                                             preferredTrackID: kCMPersistentTrackID_Invalid),
                                 let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                                             preferredTrackID: kCMPersistentTrackID_Invalid)
                           else {
                               print("트랙 추가 실패 for \(videoID)")
                               return
                           }
                           
                           guard let videoTrack = try await videoAsset.loadTracks(withMediaType: .video).first,
                                 let audioTrack = try await audioAsset.loadTracks(withMediaType: .audio).first
                                    
                          
                           else {
                               print("원본 트랙 불러오기 실패 for \(videoID)")
                               return
                           }
                           
                           do{
                               let videoDuration = try await videoAsset.load(.duration)
                                 let audioDuration = try await audioAsset.load(.duration)
                               
                                  // 각각의 재생시간을 절반으로 계산.
                                  let halfVideoDuration = CMTimeMultiplyByFloat64(videoDuration, multiplier: 0.5)
                                  let halfAudioDuration = CMTimeMultiplyByFloat64(audioDuration, multiplier: 0.5)
                                  
                                  let videoTimeRange = CMTimeRange(start: .zero, duration: halfVideoDuration)
                                  let audioTimeRange = CMTimeRange(start: .zero, duration: halfAudioDuration)
                               do {
                                   try compositionVideoTrack.insertTimeRange(videoTimeRange, of: videoTrack, at: .zero)
                                   try compositionAudioTrack.insertTimeRange(audioTimeRange, of: audioTrack, at: .zero)
                               } catch {
                                   print("스트림 결합 실패: \(error)")
                                   return
                               }
                           }
                           catch{
                               print("지속시간 로드 실패: \(error) for \(videoID)")
                                 return
                           }
                           
                           let playerItem = AVPlayerItem(asset: mixComposition)

                           await MainActor.run {
                               YoutubePlayViewModel.playerItemCache[videoID] = playerItem
                           }
                       } catch {
                           print("에러 발생: \(error) for \(videoID)")
                       }
                   }
               }
           }
       }

    func setVideoPlayer(videoID: String) {
        self.player = nil
        if let cachedItem = YoutubePlayViewModel.playerItemCache[videoID] {
            let newItem = AVPlayerItem(asset: cachedItem.asset)
            self.player = AVPlayer(playerItem: newItem)
        } else {
            print("해당 videoID에 대한 캐시된 player item이 없습니다.")
        }
    }
    
    func saveVideo(video : Video?) {
        guard let video = video else {return}
        do {
            let realm = try Realm()
            let videoObject = VideoObject(video: video)
            try realm.write {
                realm.add(videoObject, update: .modified)
            }
            //해당 videoID를 키로 하는 playerItemCache에 영상을 저장
            YoutubePlayViewModel.playerItemCache[video.id] = extractedVideo
            showSuccessToastMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showSuccessToastMessage = false
            }
        } catch {
            showErrorToastMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showErrorToastMessage = false
            }
        }
    }
    
}

extension AVMutableComposition: @unchecked @retroactive Sendable { }
