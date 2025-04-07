//
//  YouTubeAPIPlaylistResponse.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/1/25.
//

import Foundation

struct YouTubeAPIPlaylistResponse: Decodable {
    let items: [Playlist]
}
