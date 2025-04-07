//
//  YoutubeAPIResponse.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import Foundation

struct YouTubeAPIVideoResponse: Decodable {
    let items: [Video]
}
