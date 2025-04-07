//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/25/24.
//

import SwiftUI
import AVFoundation


@main
struct MusicPlayerApp: App {
    @State var isSplashOn : Bool = true
    @StateObject var youtubePlayViewModel = YoutubePlayViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            if (isSplashOn == true){
                SplashView(youtubePlayViewModel:youtubePlayViewModel,isSplashOn: $isSplashOn)
                    .onAppear{
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                            try AVAudioSession.sharedInstance().setActive(true)
                        } catch {
                            print("오디오 세션 설정 실패: \(error)")
                        }
                    }
                    .preferredColorScheme(.light)
            }
            else{
                MainView(youtubePlayViewModel: youtubePlayViewModel)
                    .preferredColorScheme(.light)
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                print("ScenePhase: 백그라운드 진입")
                if(youtubePlayViewModel.isPlaying == true){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        
                        youtubePlayViewModel.player?.play()
                        
                    }
                }
            } else if scenePhase == .active {
                print("ScenePhase: 포그라운드 진입")

            }
        }
    }
}



