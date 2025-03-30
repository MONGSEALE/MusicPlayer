//
//  VideoDetail.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation


class VideoDetail: Decodable {
    let viewCount: Int
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case statistics
    }
    
    enum StatisticsKeys: String, CodingKey {
        case viewCount, likeCount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let statisticsContainer = try container.nestedContainer(keyedBy: StatisticsKeys.self, forKey: .statistics)
        
        // API에서는 숫자가 문자열 형태로 반환
        let viewCountString = try statisticsContainer.decode(String.self, forKey: .viewCount)
        viewCount = Int(viewCountString) ?? 0
        
        let likeCountString = try statisticsContainer.decode(String.self, forKey: .likeCount)
        likeCount = Int(likeCountString) ?? 0
    }
}

