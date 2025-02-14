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
    // 여러 정보를 하나의 Song 구조체로 묶어서 관리
    @State var songs: [SongModel] = [
        SongModel(audioFileName: "Y2meta.app - Greatest Time (feat.HuhGak) (내 생애 가장 행복한 시간 (FEAT.허각)) (320 kbps)", title: "내생에 가장 행복한 시간", artist: "MC몽 ft.허각", imageName: "MC몽",duration: nil),
        SongModel(audioFileName: "Y2meta.app - 케이시 - 너 밖엔 없더라 _ Kpop _ Lyrics _ 가사 (320 kbps)", title: "너 밖엔 없더라", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - 케이시(Kassy) - 가을밤 떠난 너 _ 가사 (320 kbps)", title: "가을밤 떠난 너", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [Live Clip] 케이시(Kassy)_'사랑이야' (FOREVER LOVE) (320 kbps)", title: "사랑이야", artist: "케이시", imageName: "케이시.사랑이야",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ Nothing left to say(어떤 말도 할 수가 없는 나인데) (320 kbps)", title: "어떤 말도 할 수가 없는 나인데", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ I'll Pray For You (CASTAWAY DIVA(무인도의 디바) OST Part.7) (320 kbps)", title: "I'll pray for you", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ When love comes by(이 마음이 찾아오면) (320 kbps)", title: "이 마음이 찾아오면", artist: "케이시", imageName: "케이시다른거",duration: nil),
        SongModel(audioFileName: "[MV] 케이시 (Kassy) - 날 사랑한 처음의 너로 돌아와 [스타트업 OST Part.15 (START-UP OST Part.15)]", title: "날 사랑한 처음의 너로 돌아와", artist: "케이시", imageName: "날사랑한", duration: nil),
        SongModel(audioFileName: "[Special Clip] 케이시(Kassy)  '행복하니(Are you fine)'", title: "행복하니", artist: "케이시", imageName: "케이띠", duration: nil),
        SongModel(audioFileName: "케이시 - 오늘도 난 봄을 기다려 _ 가사 - CD MUSIC", title: "오늘도 난 봄을 기다려", artist: "케이시", imageName: "케이시또다른거",duration: nil),
        SongModel(audioFileName: "%ED%95%9C%20%ED%8E%B8%EC%9D%98%20%EA%B7%B8%EB%A6%BC%EC%B2%98%EB%9F%BC%20[BEgKKKHQktM]", title: "한 편의 그림처럼", artist: "케이시", imageName: "케이띠2", duration: nil),
        SongModel(audioFileName: "Y2meta.app - Let it rain (비야 와라) (320 kbps)", title: "비야 와라", artist: "케이시", imageName: "케이시또또다른거",duration: nil),
        SongModel(audioFileName: "Jamie Miller - Empty Room (Official Visualizer)", title: "Empty room", artist: "제이미 밀러", imageName: "제이미밀러",duration: nil),
        SongModel(audioFileName:"Alex Sampson - Play Pretend (Acoustic)" , title: "Play Pretend (Acoustic)", artist: "알렉스 샘슨", imageName: "알렉스샘슨", duration: nil),
        SongModel(audioFileName:"Before You Go (Piano Version)" , title: "Before You Go (Piano Version)", artist: "루이스 카팔디", imageName: "LewisCapaldi", duration: nil),
        SongModel(audioFileName: "Last Eden" , title: "낙원", artist: "마크튭", imageName: "마크튭찰나가" , duration: nil),
        SongModel(audioFileName:"마크툽(MAKTUB)-달 속엔 그대가 있나요, 그대 안엔 달이 있는데 (Moon inside Thee)" , title: "달 속엔 그대가 있나요, 그대 안엔 달이 있는데", artist: "마크튭", imageName: "마크튭달속에", duration: nil),
        SongModel(audioFileName: "마크툽(MAKTUB)-찰나가 영원이 될 때(The Eternal Moment)(Piano Tapes)", title: "찰나가 영원이 될 때(Piano Tapes)", artist: "마크튭", imageName: "마크튭찰나가", duration: nil),
        SongModel(audioFileName: "다비치 - 두사랑 (Feat. 매드클라운) [가사-Lyrics]", title: "두사랑", artist: "다비치", imageName: "다비치", duration: nil),
        SongModel(audioFileName: "Davichi(다비치) - You Are My Everything [Eng Sub + Han + Rom] HD", title: "You are my everything", artist: "다비치", imageName: "다비치", duration: nil),
        SongModel(audioFileName: "My heart is beating (가슴이 뛴다)", title: "가슴이 뛴다", artist: "케이윌", imageName: "케이윌", duration: nil),
        SongModel(audioFileName: "Clinton Kane - Fix It to Break It (Official Video)", title: "Fix It To Break It", artist: "클린턴 케인", imageName: "ClintonKane", duration: nil),
        SongModel(audioFileName: "Avril Lavigne - Sk8er Boi (Official Lyric Video)", title: "Sk8er Boi", artist: "에이브릴 라빈", imageName: "AvrilLavigne", duration: nil),
        SongModel(audioFileName: "Thomas Day - not my job anymore (Lyrics)" , title: "Not My Job Anymore", artist: "토마스 데이", imageName: "ThomasDay", duration: nil),
        SongModel(audioFileName: "Wish You The Best (Guitar Version)", title: "Wish you the best(Guitar version)", artist: "루이스 카팔디", imageName: "LewisCapaldi", duration: nil),
        SongModel(audioFileName: "Lewis Capaldi - A Cure For Minds Unwell (Lyrics)", title: "A Cure For Minds Unwell", artist: "루이스 카팔디", imageName: "LewisCapaldi", duration: nil),
        SongModel(audioFileName: "리아(LIA)(ITZY) - 푸른꽃 (Blue Flower) (환혼_ 빛과 그림자 OST) Alchemy of Souls_ Light and Shadow OST Part 1", title: "푸른꽃", artist: "리아(ITZY)", imageName: "리아", duration: nil),
        SongModel(audioFileName: "Justin Bieber - Ghost (Visualizer)", title: "Ghost", artist: "저스틴 비버", imageName: "JustinBieber", duration: nil),
        SongModel(audioFileName: "STAY", title: "Stay", artist: "더 키드 라로이 & 저스틴 비버", imageName: "Stay", duration: nil),
        SongModel(audioFileName: "One Direction - Perfect (Audio)", title: "Perfect", artist: "원 디렉션", imageName: "Perfect", duration: nil),
        SongModel(audioFileName:"It's Always Been You - Phil Wickham (Lyrics)" , title: "It's Always Been You", artist: "필 윅컴", imageName: "PhilWickham", duration: nil),
        SongModel(audioFileName: "Dean Lewis, Sasha Alex Sloan - Rest (with Sasha Alex Sloan) (Official Audio)", title: "Rest", artist: "딘루이스 & 사샤슬론", imageName: "딘루이스&사샤슬론", duration: nil),
        SongModel(audioFileName: "Avril Lavigne - Here's To Never Growing Up (Audio)", title: "Here's To Never Growing Up", artist: "에이브릴 라빈", imageName: "AvrilLavigne2", duration: nil),
        SongModel(audioFileName: "Still%20New%20York%20%28feat.%20Joey%20Bada__%29%20[iK3xwtjFIB4]", title: "Still New York", artist: "맥스 & 조이 베이다", imageName: "Max", duration: nil),
        SongModel(audioFileName:"볼빨간사춘기 - 사랑할 수밖에  Kpop  Lyrics  가사" , title: "사랑할 수 밖에", artist: "볼빨간사춘기", imageName: "볼빨사", duration: nil),
        SongModel(audioFileName: "The Reklaws - I Do Too (Audio)", title: "I Do Too", artist: "레클로우즈", imageName: "Reklaws", duration: nil)
    ]
    
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
                        Slider(value: Binding(get: { currentTime }, set: { newValue in audioTime(to: newValue) }), in: 0...totalTime)
                            .padding([.top, .trailing, .leading], 20)
                    }
                    HStack(spacing: 20) {
                        Button {
                            if currentSongIndex > 0 {  // currentMusicPage를 0에서 시작하므로 0보다 클 때만 감소
                                // stopAudio()
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

