//
//  PlayListSheet.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/5/24.
//

import SwiftUI

struct PlayListSheet: View {
    let SongDatas : [SongModel]
    @Binding var currentSong : Int
    var body: some View {
        ZStack{
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            VStack{
                Text("재생목록")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.title3)
                ScrollView{
                    VStack(spacing:0){
                        ForEach(SongDatas.indices, id: \.self) { index in
                            let song = SongDatas[index]
                            PlayListRowView(imageName: song.imageName, title: song.title, artist: song.artist,duration: song.duration)
                                .onTapGesture {
                                    currentSong = index
                                }
                                .background(currentSong == index ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color(red: 0.2, green: 0.2, blue: 0.2))
                        }
                    }
                }
                .padding(.bottom,50)
                .padding(.top,20)
            }
        }
    }
}

#Preview {
    PlayListSheet(SongDatas:[
        SongModel(audioFileName: "Y2meta.app - Greatest Time (feat.HuhGak) (내 생애 가장 행복한 시간 (FEAT.허각)) (320 kbps)", title: "내생에 가장 행복한 시간", artist: "MC몽 ft.허각", imageName: "MC몽",duration: nil),
        SongModel(audioFileName: "Y2meta.app - 케이시 - 너 밖엔 없더라 _ Kpop _ Lyrics _ 가사 (320 kbps)", title: "너 밖엔 없더라", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - 케이시(Kassy) - 가을밤 떠난 너 _ 가사 (320 kbps)", title: "가을밤 떠난 너", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [Live Clip] 케이시(Kassy)_'사랑이야' (FOREVER LOVE) (320 kbps)", title: "사랑이야", artist: "케이시", imageName: "케이시.사랑이야",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ Nothing left to say(어떤 말도 할 수가 없는 나인데) (320 kbps)", title: "어떤 말도 할 수가 없는 나인데", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ I'll Pray For You (CASTAWAY DIVA(무인도의 디바) OST Part.7) (320 kbps)", title: "I'll pray for you", artist: "케이시", imageName: "케이시",duration: nil),
        SongModel(audioFileName: "Y2meta.app - [MV] Kassy(케이시) _ When love comes by(이 마음이 찾아오면) (320 kbps)", title: "이 마음이 찾아오면", artist: "케이시", imageName: "케이시다른거",duration: nil),
        SongModel(audioFileName: "케이시 - 오늘도 난 봄을 기다려 _ 가사 - CD MUSIC", title: "오늘도 난 봄을 기다려", artist: "케이시", imageName: "케이시또다른거",duration: nil),
        SongModel(audioFileName: "Y2meta.app - Let it rain (비야 와라) (320 kbps)", title: "비야 와라", artist: "케이시", imageName: "케이시또또다른거",duration: nil)
    ],currentSong: .constant(1) )
}
