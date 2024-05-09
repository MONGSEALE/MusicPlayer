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
    let audio : [Int:String] = [1:"Y2meta.app - Greatest Time (feat.HuhGak) (내 생애 가장 행복한 시간 (FEAT.허각)) (320 kbps)",2:"Y2meta.app - 케이시 - 너 밖엔 없더라 _ Kpop _ Lyrics _ 가사 (320 kbps)",3:"Y2meta.app - 케이시(Kassy) - 가을밤 떠난 너 _ 가사 (320 kbps)",4:"Y2meta.app - [Live Clip] 케이시(Kassy)_'사랑이야' (FOREVER LOVE) (320 kbps)",5:"Y2meta.app - [MV] Kassy(케이시) _ Nothing left to say(어떤 말도 할 수가 없는 나인데) (320 kbps)",6:"Y2meta.app - [MV] Kassy(케이시) _ I'll Pray For You (CASTAWAY DIVA(무인도의 디바) OST Part.7) (320 kbps)",7:"Y2meta.app - [MV] Kassy(케이시) _ When love comes by(이 마음이 찾아오면) (320 kbps)",8:"케이시 - 오늘도 난 봄을 기다려 _ 가사 - CD MUSIC",9:"Y2meta.app - Let it rain (비야 와라) (320 kbps)"]
    let audioTitle : [Int:String] = [1:"내생에 가장 행복한 시간",2:"너 밖엔 없더라",3:"가을밤 떠난 너",4:"사랑이야",5:"어떤 말도 할 수가 없는 나인데",6:"I'll pray for you",7:"이 마음이 찾아오면",8:"오늘도 난 봄을 기다려",9:"비야 와라"]
    let songArtist : [Int:String] = [1:"MC몽 ft.허각",2:"케이시",3:"케이시",4:"케이시",5:"케이시",6:"케이시",7:"케이시",8:"케이시",9:"케이시"]
    let songImage : [Int:String] = [1:"MC몽",2:"케이시",3:"케이시",4:"케이시.사랑이야",5:"케이시",6:"케이시",7:"케이시다른거",8:"케이시또다른거",9:"케이시또또다른거"]
    @State var audioFile = ""
    @State var currentMusicPage : Int = 1
    @State private var player : AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    @State private var audioDelegate: AudioPlayerDelegate?
    @State private var isRepeated : Bool = false
    @State private var isDragging = false
    @State private var offset = CGFloat.zero
    @State var showSheet : Bool = false
    var body: some View {
        ZStack(alignment: .bottom){
        VStack {
            ZStack{
                HStack{
                    Spacer()
                    ModifiedButtonView(image: "line.horizontal.3.decrease")
                }
                Text("몽실이의 음악앱")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(.all)
            .padding(.top,50)
            Image(songImage[currentMusicPage] ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .clipShape(Circle())
                .padding(.all,8)
                .background(Color(#colorLiteral(red:0.890392157,green:0.9333333333,blue:1,alpha:1)))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.35),radius: 8 , x: 8 , y:8)
                .shadow(color: Color.white, radius: 10,x: -10,y: -10)
                .padding(.top,35)
            Text(audioTitle[currentMusicPage] ?? "")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top,25)
            Text(songArtist[currentMusicPage] ?? "")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.top,2)
            VStack{
                HStack{
                    Text(timeString(time:currentTime))
                    Spacer()
                    Text(timeString(time: totalTime))
                }
                .font(.caption)
                .foregroundStyle(.black.opacity(0.8))
                .padding([.top, .trailing, .leading],20)
                Slider(value:Binding(get:{currentTime},set:{newValue in audioTime(to: newValue)}),in: 0...totalTime)
                    .padding([.top,.trailing,.leading],20)
            }
            HStack(spacing:20){
                Button{
                    if (currentMusicPage > 1){
                        stopAudio()
                        self.currentMusicPage = currentMusicPage - 1
                    }
                } label: {
                    ModifiedButtonView(image: "backward.fill")
                }
                Button {
                    isPlaying ? stopAudio() : playAudio()
                } label: {
                    ModifiedButtonView(image: isPlaying ? "pause.fill" : "play.fill")
                }
                Button{
                    if (currentMusicPage < audio.count){
                        stopAudio()
                        self.currentMusicPage = currentMusicPage + 1
                    }
                } label: {
                    ModifiedButtonView(image: "forward.fill")
                }
                Button{
                    isRepeated.toggle()
                }label: {
                    ModifiedButtonView(image: isRepeated ? "repeat.1" : "repeat")
                }
            }
            .padding(.top, 25)
            Spacer()
        }
        .background(Color(#colorLiteral(red:0.890392157,green:0.9333333333,blue:1,alpha:1)))
            SheetView()
                .frame(height: showSheet ? 700 : 70) // 드래그 상태에 따라 높이 변경
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {
                    showSheet = true
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let verticalMovement = gesture.translation.height
                            self.offset = verticalMovement
                            if verticalMovement < 0 { // 위로 드래그하는 경우
                                isDragging = true
                            }
                        }
                        .onEnded { _ in
                            if self.offset > 50 { // 다시 내려가는 드래그가 일정 이상일 경우
                                isDragging = false // 뷰를 다시 하단으로 숨김
                            }
                            self.offset = 0
                        }
                )
                .animation(.spring(), value: isDragging)
                .animation(.spring(), value: showSheet)
    }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            currentMusicPage = 1
            audioFile = audio[currentMusicPage] ?? ""
            setupAudio()
        })
        .onChange(of:currentMusicPage){
            audioFile = audio[currentMusicPage] ?? ""
            setupAudio()
            playAudio()
        }
        .onReceive(Timer.publish(every: 0.1,on: .main , in: .common).autoconnect()) { _ in
            updateProgress()
            print("currentTime값:\(currentTime)")
        }
    }
    private func setupAudio(){
        guard let url = Bundle.main.url(forResource: audioFile, withExtension: "mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            audioDelegate = AudioPlayerDelegate(parent: self)
            player?.delegate = audioDelegate
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        }
        catch{
            print("Error loading audio")
        }
    }
    private func playAudio(){
        player?.play()
        isPlaying = true
    }
    private func stopAudio(){
        player?.stop()
        isPlaying = false
    }
    private func updateProgress(){
        guard let player = player else {return}
        currentTime = player.currentTime
    }
    private func audioTime(to time:TimeInterval){
        player?.currentTime = time
    }
    private func timeString(time:TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02d:%02d",minute,seconds)
    }
    func moveToNextSong() {
        if(isRepeated == true){
            playAudio()
        }
        else{
            if currentMusicPage < audio.count {
                currentMusicPage += 1
            }
            else{
                isPlaying = false
            }
        }
        }
}

#Preview {
    ContentView()
}

struct ModifiedButtonView: View {
    var image : String
    var body: some View {
            Image(systemName: image)
                .font(.system(size: 14,weight: .bold))
                .padding(.all,25)
                .foregroundStyle(.black.opacity(0.8))
                .background(
                    ZStack{
                        Color(#colorLiteral(red:0.7608050108,green: 0.8164883852, blue: 0.9259157777,alpha:1))
                        Circle()
                            .foregroundStyle(.white)
                            .blur(radius: 4)
                            .offset(x: -8,y: -8)
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white,Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                            .blur(radius: 2)
                    }
                        .clipShape(Circle())
                        .shadow(color: Color(#colorLiteral(red:0.7608050108,green:0.8164883852,blue:0.9259157777,alpha:1)),radius: 20,x: 20,y:20)
                        .shadow(color: .white,radius: 20, x: -20, y: -20)
                )
    }
}
