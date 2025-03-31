//
//  SplashView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/12/25.
//

import SwiftUI
import RealmSwift
import Lottie

struct SplashView: View {
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @ObservedResults(VideoObject.self) var videos
    @Binding var isSplashOn : Bool
    var convertedIDs: [String] {
        videos.map { Video(from: $0).id }
    }
    @State private var isAnimating = false
    @State private var toLoadingView : Bool = false
    
    var body: some View {
        ZStack{
            if(toLoadingView == true){
                VStack{
                    Spacer()
                    VStack(spacing:20){
                        LottieView(animation: .named("Animation - 1743387065188"))
                            .playing()
                            .looping()
                        Text("저장한 음악 가져오는중...")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    Spacer()
                }
                .background(GrayGradient())
                .ignoresSafeArea()
            }
            else{
                ZStack{
                    Image("IconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 256)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                toLoadingView = true
                            }
                        }
                }
            }
        }
        .onAppear{
            Task{
                isSplashOn = true
                await youtubePlayViewModel.extractAndStoreVideos(videoIDs: convertedIDs)
                isSplashOn = false
            }
        }
    }
}


#Preview {
    SplashView(youtubePlayViewModel : YoutubePlayViewModel(),isSplashOn: .constant(true) )
}


