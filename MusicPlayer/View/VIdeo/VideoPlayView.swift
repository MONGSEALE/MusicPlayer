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



struct VideoPlayView: View {
    
    @Binding var video: Video?
    @Binding var startingOffset: CGFloat
    @Binding var currentOffset: CGFloat
    @Binding var endOffset: CGFloat
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @Binding var index : Int
    @Binding var maxIndex : Int
    @State private var isRepeated : Bool = false
    
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
                    .padding()
                }
                Spacer()
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
