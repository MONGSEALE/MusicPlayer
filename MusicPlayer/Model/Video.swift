//
//  Video.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import Foundation


struct Video: Identifiable, Decodable, Equatable ,Hashable{
    let id: String
    let title: String
    let thumbnail: URL
    let channelTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    enum IDKeys: String, CodingKey {
        case videoId
    }
    
    enum SnippetKeys: String, CodingKey {
        case title, thumbnails, channelTitle
    }
    
    enum ThumbnailsKeys: String, CodingKey {
        case medium
    }
    
    enum MediumKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idString = try? container.decode(String.self, forKey: .id) {
                  id = idString
              } else {
                  // search API의 경우처럼 id가 딕셔너리 형태라면 videoId를 추출
                  let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
                  id = try idContainer.decode(String.self, forKey: .videoId)
              }
        
        // id 객체 내의 videoId
//        let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
//        id = try idContainer.decode(String.self, forKey: .videoId)
        
        // snippet 내의 제목, 채널 이름, 썸네일 정보
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        title = try snippetContainer.decode(String.self, forKey: .title)
        channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle) // 채널 이름 디코딩
        
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsKeys.self, forKey: .thumbnails)
        let mediumContainer = try thumbnailsContainer.nestedContainer(keyedBy: MediumKeys.self, forKey: .medium)
        let thumbnailString = try mediumContainer.decode(String.self, forKey: .url)
        thumbnail = URL(string: thumbnailString) ?? URL(string: "https://")!
    }
}



