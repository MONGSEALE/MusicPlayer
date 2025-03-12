//
//  SplashView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/12/25.
//

import SwiftUI
import RealmSwift

struct SplashView: View {
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @ObservedResults(VideoObject.self) var videos
    @Binding var isSplashOn : Bool
    var convertedIDs: [String] {
        videos.map { Video(from: $0).id }
    }
    var body: some View {
        ZStack{
            Text("스플래쉬입니둥")
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
