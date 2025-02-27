//
//  ContentView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/25/24.
//

import SwiftUI
import AVKit

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var parent: ContentView
    init(parent: ContentView) {
        self.parent = parent
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            parent.moveToNextSong()
        }
    }
}


struct ContentView: View {
    @State var songs = dummyData
    @State var currentSongIndex: Int = 0
    @State private var offsetY: CGFloat = 0
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    @State private var audioDelegate: AudioPlayerDelegate?
    @State private var isRepeated: Bool = false
    @State private var bottomSheetHeight: CGFloat = 80
    
    var body: some View {
            ZStack(alignment: .bottom) {
                VStack {
                    Text("몽실이의 음악앱")
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.all)
                        .padding(.top, 50)
                    Image(songs[currentSongIndex].imageName)  // currentMusicPage를 0부터 시작하도록 수정
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .clipShape(Circle())
                        .padding(.all, 8)
                        .background(Color(red: 0.23, green: 0.23, blue: 0.23))
                        .clipShape(Circle())
                        .padding(.top, 35)
                        .frame(height: 200)
                    Text(songs[currentSongIndex].title)  // currentMusicPage 수정
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 100)
                        .padding(.top, 10)
                    Text(songs[currentSongIndex].artist)  // currentMusicPage 수정
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
                      //  Slider(value: Binding(get: { currentTime }, set: { newValue in audioTime(to: newValue) }), in: 0...totalTime)
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
                            if currentSongIndex > 0 {  // currentMusicPage를 0에서 시작하므로 0보다 클 때만 감소
                                self.currentSongIndex -= 1
                            }
                        } label: {
                            ModifiedButtonView(image: "backward.fill")
                        }
                        Button {
                            isPlaying ? stopAudio() : playAudio()
                        } label: {
                            ModifiedButtonView(image: isPlaying ? "pause.fill" : "play.fill")
                        }
                        Button {
                            if currentSongIndex < songs.count - 1 {  // currentMusicPage 수정
                                self.currentSongIndex += 1
                            }
                        } label: {
                            ModifiedButtonView(image: "forward.fill")
                        }
                        Button {
                            isRepeated.toggle()
                        } label: {
                            ModifiedButtonView(image: isRepeated ? "repeat.1" : "repeat")
                        }
                    }
                    .padding(.top, 25)
                    Spacer()
                }
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                
                BottomSheetRepresentable(currentSong: $currentSongIndex, songs: songs, currentHeight: $bottomSheetHeight)
                    .frame(height: bottomSheetHeight)  // BottomSheetViewController의 전체 높이와 동일하게
                                 .edgesIgnoringSafeArea(.all)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                currentSongIndex = 0  // 초기 값도 0으로 설정
                setupAudio()
                let screenHeight = UIScreen.main.bounds.height
                self.offsetY = screenHeight - 70
            })
            .onChange(of: currentSongIndex) {
                stopAudio()
                setupAudio()
                playAudio()
            }
            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                updateProgress()
            }
    }
    
    private func setupAudio() {
        let audioFileName = songs[currentSongIndex].audioFileName  // currentMusicPage 수정
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
            print("Error loading audio")
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
            if currentSongIndex < songs.count - 1 {  // currentMusicPage 수정
                currentSongIndex += 1
            } else {
                isPlaying = false
            }
        }
    }
}

struct BottomSheetRepresentable: UIViewControllerRepresentable {
    @Binding var currentSong: Int
    var songs: [SongModel]
    @Binding var currentHeight: CGFloat   // 새로 추가한 바인딩
    
    func makeUIViewController(context: Context) -> BottomSheetViewController {
        let vc = BottomSheetViewController()
        vc.songs = songs
        vc.currentSongIndexBinding = $currentSong
        vc.currentHeightBinding = $currentHeight   // 바인딩 전달
        return vc
    }
    
    func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        uiViewController.songs = songs
        uiViewController.currentSongIndexBinding = $currentSong
        uiViewController.currentHeightBinding = $currentHeight
    }
}




#Preview {
    ContentView()
}

