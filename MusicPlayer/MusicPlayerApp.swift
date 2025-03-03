//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/25/24.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            MusicPlayerView( currentSongIndex: .constant(0),song: .constant(dummyData[0]),currentHeight: .constant(80))
        }
    }
}
