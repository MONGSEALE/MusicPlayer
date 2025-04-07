//
//  ContentView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/25/24.
//

import SwiftUI
import AVKit

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var parent: MusicPlayView
    init(parent: MusicPlayView) {
        self.parent = parent
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            parent.moveToNextSong()
        }
    }
}

struct MusicPlayView: View {
    @State var songs = dummyData
    @Binding var currentSongIndex: Int?
    @Binding var song : SongModel?
    @Binding var currentHeight : CGFloat?
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    @State private var audioDelegate: AudioPlayerDelegate?
    @State private var isRepeated: Bool = false
    private let sheetTotalHeight = UIScreen.main.bounds.height * 0.8
    private let sheetVisibleHeight: CGFloat = 100
    private var maxSheetHeight: CGFloat {
        sheetTotalHeight - sheetVisibleHeight
    }
    var firstVStackOpacity: Double {
        let height = currentHeight ?? sheetVisibleHeight
        // 최소값에서 최대값까지 선형 보간 (0 ~ 1)
        let normalized = (height - sheetVisibleHeight) / (maxSheetHeight - sheetVisibleHeight)
        return Double(min(max(normalized, 0), 1))
    }
    var secondVStackOpacity: Double {
        1 - firstVStackOpacity
    }
    var body: some View {
        ZStack{
                VStack {
                    Spacer()
                    Image(song?.imageName ?? "")  // currentMusicPage를 0부터 시작하도록 수정
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .clipShape(Circle())
                        .padding(.all, 8)
                        .background(Color(red: 0.23, green: 0.23, blue: 0.23))
                        .clipShape(Circle())
                        .padding(.top, 35)
                        .frame(height: 200)
                    Text(song?.title ?? "")  // currentMusicPage 수정
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 100)
                        .padding(.top, 10)
                    Text(song?.artist ?? "")  // currentMusicPage 수정
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    VStack {
                        HStack {
                            Text(timeString(time: currentTime))
                            Spacer()
                            Text(timeString(time: totalTime))
                        }
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding([.top, .trailing, .leading], 20)
                        CustomSlider(
                            value: Binding(
                                get: { currentTime },
                                set: { newValue in
                                    currentTime = newValue
                                    audioTime(to: newValue)
                                }
                            ),
                            range: 0...totalTime
                        )
                        .padding([.top, .trailing, .leading], 20)
                    }
                    HStack(spacing: 20) {
                        Button {
                            if currentSongIndex ?? 0 > 0 {  // currentMusicPage를 0에서 시작하므로 0보다 클 때만 감소
                                self.currentSongIndex! -= 1
                            }
                        } label: {
                            PlayButtonView(image: "backward.fill")
                        }
                        Button {
                            isPlaying ? stopAudio() : playAudio()
                        } label: {
                            PlayButtonView(image: isPlaying ? "pause.fill" : "play.fill")
                        }
                        Button {
                            if currentSongIndex ?? 0 < songs.count - 1 {  // currentMusicPage 수정
                                self.currentSongIndex! += 1
                            }
                        } label: {
                            PlayButtonView(image: "forward.fill")
                        }
                        Button {
                            isRepeated.toggle()
                        } label: {
                            PlayButtonView(image: isRepeated ? "repeat.1" : "repeat")
                        }
                    }
                    .padding(.top, 25)
                    .padding(.bottom,100)
                    Spacer()
                }
                .opacity(firstVStackOpacity)
                VStack{
                    HStack{
                        
                        Image(song?.imageName ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(Circle())
                            .padding(.all, 4)
                            .background(Color(red: 0.23, green: 0.23, blue: 0.23))
                            .clipShape(Circle())
                            .padding(.top)
                        
                        VStack(spacing:10){
                                HStack{
                                    Text(song?.title ?? "")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .lineLimit(1)              
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                HStack{
                                    Text(song?.artist ?? "")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                            }
                        .padding(.top)
              
                            HStack{
                                Button {
                                    if currentSongIndex ?? 0 > 0 {  // currentMusicPage를 0에서 시작하므로 0보다 클 때만 감소
                                        self.currentSongIndex! -= 1
                                    }
                                } label: {
                                    Image(systemName: "backward.fill")
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    isPlaying ? stopAudio() : playAudio()
                                } label: {
                                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    if currentSongIndex ?? 0 < songs.count - 1 {  // currentMusicPage 수정
                                        self.currentSongIndex! += 1
                                    }
                                } label: {
                                    Image(systemName: "forward.fill")
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.top)
                            .padding()
          
                    }
                    HStack{
                        Spacer()
                    }
                    Spacer()
                }
                .opacity(secondVStackOpacity)
        }
        .background(GrayGradient())
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if (player != nil){
                playAudio()
            }
            else{
                setupAudio()
            }
        }
        .onChange(of: currentSongIndex) {
            stopAudio()
            setupAudio()
            playAudio()
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
        .onDisappear{
            stopAudio()
        }
    }
    
    private func setupAudio() {
        let audioFileName = song?.audioFileName  // currentMusicPage 수정
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            audioDelegate = AudioPlayerDelegate(parent: self)
            player?.delegate = audioDelegate
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("오디오 로딩 에러")
        }
    }
    
    private func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        player?.stop()
        isPlaying = false
    }
    
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    private func audioTime(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    func moveToNextSong() {
        if isRepeated {
            playAudio()
        } else {
            if currentSongIndex ?? 0 < songs.count - 1 {  // currentMusicPage 수정
                currentSongIndex! += 1
            } else {
                isPlaying = false
            }
        }
    }
}


#Preview {
    MusicPlayView(currentSongIndex: .constant(0), song:.constant(dummyData[0]),currentHeight: .constant(80))
}

