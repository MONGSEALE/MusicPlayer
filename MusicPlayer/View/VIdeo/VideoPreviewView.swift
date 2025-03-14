//
//  VideoPreviewView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/12/25.
//

import SwiftUI
import RealmSwift
import AVKit

struct VideoPreviewView: View {
    @Binding var video : Video?
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @State private var showSuccessToastMessage: Bool = false
    @State private var showErrorToastMessage: Bool = false
    @State private var extractionTask: Task<Void, Never>? = nil
    var body: some View {
        ZStack{
            GrayGradient()
            VStack(spacing: 16){
                Spacer()
                if let player = youtubePlayViewModel.player {
                    VideoPlayer(player: player)
                        .frame(height: 300)
                        .onAppear { player.play() }
                } else {
                    ZStack{
                        Text("로딩중...")
                            .foregroundColor(.white)
                    }
                    .frame(height:300)
                }
                MarqueeText(
                    text: video?.title ?? "" ,
                    font: UIFont.preferredFont(forTextStyle: .title2),
                    leftFade: 16,
                    rightFade: 16,
                    startDelay: 1,
                    fontWeight: .semibold,
                    foregroundStyle: .white
                )
                .padding()
                Button{
                    youtubePlayViewModel.saveVideo(video: video)
                } label: {
                    ModifiedButtonView(text: "저장하기",isEnabled: youtubePlayViewModel.isButtonEnabled)
                }
                .disabled(!youtubePlayViewModel.isButtonEnabled)
                Spacer()
            }
            if (youtubePlayViewModel.showSuccessToastMessage == true){
                ToastMessage(type: .saved, title: "성공", message: "저장하였습니다", onCancelTapped: {youtubePlayViewModel.showSuccessToastMessage = false})
            }
            else if(youtubePlayViewModel.showErrorToastMessage == true){
                ToastMessage(type: .saved, title: "실패", message: "저장에 실패하였습니다", onCancelTapped: {youtubePlayViewModel.showErrorToastMessage = false})
            }
        }
        .onAppear{
            youtubePlayViewModel.player = nil
            extractionTask = Task {
                guard let video = video else { return }
                await youtubePlayViewModel.extractVideo(videoID: video.id)
            }
        }
        .onDisappear {
            extractionTask?.cancel()
            Task { @MainActor in
                  youtubePlayViewModel.player = nil
              }
        }
    }
    
}

//#Preview {
//    VideoPreviewView()
//}
