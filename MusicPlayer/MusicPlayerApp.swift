//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/25/24.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    @State var isSplashOn : Bool = true
    @StateObject var youtubePlayViewModel = YoutubePlayViewModel()
    var body: some Scene {
        WindowGroup {
            if (isSplashOn == true){
                SplashView(youtubePlayViewModel:youtubePlayViewModel,isSplashOn: $isSplashOn)
            }
            else{
                MainView(youtubePlayViewModel: youtubePlayViewModel)
            }
        }
    }
}


