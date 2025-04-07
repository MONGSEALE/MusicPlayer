//
//  Playlist.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/1/25.
//

import Foundation

struct Playlist: Identifiable, Decodable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let thumbnail: URL
    let channelTitle: String
    var videos: [Video]? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    enum IDKeys: String, CodingKey {
        case playlistId
    }
    
    enum SnippetKeys: String, CodingKey {
        case title, description, thumbnails, channelTitle
    }
    
    enum ThumbnailsKeys: String, CodingKey {
        case medium
    }
    
    enum MediumKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // id 객체 내의 playlistId
        let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .playlistId)
        
        // snippet 내의 제목, 설명, 채널 이름, 썸네일 정보
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        title = try snippetContainer.decode(String.self, forKey: .title)
        description = try snippetContainer.decode(String.self, forKey: .description)
        channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsKeys.self, forKey: .thumbnails)
        let mediumContainer = try thumbnailsContainer.nestedContainer(keyedBy: MediumKeys.self, forKey: .medium)
        let thumbnailString = try mediumContainer.decode(String.self, forKey: .url)
        thumbnail = URL(string: thumbnailString) ?? URL(string: "https://")!
    }
    
    // 더미 데이터를 위한 커스텀 초기화 생성자
    init(id: String, title: String, description: String, thumbnail: URL, channelTitle: String, videos: [Video]? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
        self.channelTitle = channelTitle
        self.videos = videos
    }
}
