//
//  VideoPlayerView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import SwiftUI
import WebKit
import RealmSwift
import YouTubeKit
import AVKit
import MediaPlayer



struct VideoPlayView: View {
    
    @Binding var video: Video?
    @Binding var startingOffset: CGFloat
    @Binding var currentOffset: CGFloat
    @Binding var endOffset: CGFloat
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @Binding var index : Int
    @Binding var maxIndex : Int
    @Binding var youtubeURL : URL?
    @State private var isRepeated : Bool = false
    @ObservedObject var youtubeSearchViewModel : YouTubeSearchViewModel
    
    var body: some View {
        // 전체 오프셋을 계산하여 progress(0: 최소상태, 1: 완전히 열린 상태)로 변환
        let totalOffset = startingOffset + currentOffset + endOffset
        let progress = 1 - (totalOffset / startingOffset)
        
        ZStack {
            // 최소 상태일 때 보여줄 상단의 작은 버전
            HStack(alignment: .top, spacing: 8) {
                ZStack{
                    if let player = youtubePlayViewModel.player {
                        VideoPlayer(player: player)
                            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { notification in
                                if(isRepeated == true){
                                    if let player = youtubePlayViewModel.player {
                                        player.seek(to: .zero) { _ in
                                            player.play()
                                        }
                                    }
                                }
                                else{
                                    if (index < maxIndex){
                                        youtubePlayViewModel.player = nil
                                        index = index + 1
                                    }
                                }
                            }
                    }
                }
                .frame(width: 100, height: 56)
                VStack(spacing:8){
                    HStack{
                        Text(video?.title ?? "")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .font(.title3)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    HStack(spacing:16){
                        Spacer()
                        Button{
                            if (index > 0){
                                youtubePlayViewModel.player = nil
                                index = index - 1
                            }
                        }label: {
                            Image(systemName: "backward.fill")
                                .foregroundColor(.white)
                        }
                        Group {
                            if let player = youtubePlayViewModel.player, player.rate > 0 {
                                Button(action: {
                                    player.pause()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .foregroundColor(.white)
                                }
                            } else {
                                Button(action: {
                                    youtubePlayViewModel.player?.play()
                                }) {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        Button{
                            if (index < maxIndex){
                                youtubePlayViewModel.player = nil
                                index = index + 1
                            }
                        }label: {
                            Image(systemName: "forward.fill")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                }
                .frame(height: 56)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .opacity(1 - progress)
            
            // 완전히 열린 상태일 때 보여줄 중앙의 큰 버전
            VStack(spacing: 16) {
                Spacer()
                VStack{
                    if let player = youtubePlayViewModel.player {
                        VideoPlayer(player: player)
                            .frame(height: 300)
                            .onAppear {
                                player.play()
                            }
                    } else {
                        ZStack{
                            Text("")
                        }
                        .frame(height: 300)
                    }
                    VStack(spacing:20){
                        MarqueeText(
                            text: video?.title ?? "기본 텍스트",
                            font: UIFont.preferredFont(forTextStyle: .title2),
                            leftFade: 16,
                            rightFade: 16,
                            startDelay: 1,
                            fontWeight: .semibold,
                            foregroundStyle: .white
                        )
                        .id(endOffset == -startingOffset ? "fullyOpen" : "notFullyOpen")
                        HStack{
                            Text(video?.channelTitle ?? "")
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        HStack(spacing:20){
                            Text("조회수 \(formattedCount(youtubeSearchViewModel.videoDetail?.viewCount))")
                                .customCapsule()
                            HStack{
                                Image(systemName: "hand.thumbsup")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundStyle(.white)
                                Text(formattedCount(youtubeSearchViewModel.videoDetail?.likeCount))
                            }
                            .customCapsule()
                            if let youtubeURL = youtubeURL {
                                ShareLink(item: youtubeURL) {
                                    Text("공유하기")
                                        .customCapsule()
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                HStack{
                    Spacer()
                    Button{
                        if (index > 0){
                            youtubePlayViewModel.player = nil
                            index = index - 1
                        }
                    }label: {
                        PlayButtonView(image: "backward.fill")
                    }
                    Spacer()
                    Group {
                        if let player = youtubePlayViewModel.player, player.rate > 0 {
                            // 재생 중 → 정지 버튼 표시
                            Button(action: {
                                player.pause()
                            }) {
                                PlayButtonView(image: "stop.fill")
                            }
                        } else {
                            // 정지 상태 → 재생 버튼 표시
                            Button(action: {
                                youtubePlayViewModel.player?.play()
                            }) {
                                PlayButtonView(image: "play.fill")
                            }
                        }
                    }
                    Spacer()
                    Button{
                        if (index < maxIndex){
                            youtubePlayViewModel.player = nil
                            index = index + 1
                        }
                    }label: {
                        PlayButtonView(image: "forward.fill")
                    }
                    Spacer()
                    Button{
                        isRepeated.toggle()
                    } label: {
                        PlayButtonView(image: isRepeated ? "repeat.1" : "repeat")
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .opacity(progress)
        }
    }
    
    func setupRemoteCommands(for player: AVPlayer) {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            player.play()
            // 재생 시작 시 최신 Now Playing 정보를 업데이트
            updateNowPlayingInfo(title: "비디오 제목", imageURL: URL(string: "https://i.ytimg.com/vi/MuGILtV4cUk/mqdefault.jpg")!, player: player)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            player.pause()
            return .success
        }
 
    }
    
    // Now Playing 정보 업데이트 함수 (비동기적으로 이미지 로드)
    func updateNowPlayingInfo(title: String, imageURL: URL, player: AVPlayer) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("이미지 로드 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // 요청된 크기에 맞춰 artwork를 생성
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { requestedSize in
                // 필요 시 여기서 이미지 리사이징을 할 수 있음
                return image
            }
            
            // 재생 시간, 경과 시간, 재생 속도 등 추가 메타데이터도 포함
            let duration = player.currentItem?.duration.seconds ?? 0
            let elapsed = player.currentTime().seconds
            let playbackRate = player.rate
            
            let nowPlayingInfo: [String: Any] = [
                MPMediaItemPropertyTitle: title,
                MPMediaItemPropertyArtwork: artwork,
                MPMediaItemPropertyPlaybackDuration: duration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: elapsed,
                MPNowPlayingInfoPropertyPlaybackRate: playbackRate
            ]
            
            DispatchQueue.main.async {
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                print("Now Playing 정보 업데이트됨: \(nowPlayingInfo)")
            }
        }.resume()
    }
    
}


//#Preview {
//    VideoPlayView(
//        video: .constant(
//            Video(
//                id: "dummyID",
//                title: "테스트 비디오",
//                thumbnail: URL(string: "https://example.com/thumbnail.jpg")!
//            )
//        ),
//        isAddable: false
//    )
//}
