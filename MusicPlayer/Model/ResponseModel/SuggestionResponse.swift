//
//  SuggestionResponse.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/7/25.
//

import Foundation

struct SuggestionResponse: Decodable {
    let suggestions: [String]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        // 첫 번째 요소: 검색어 (사용하지 않음)
        _ = try container.decode(String.self)
        // 두 번째 요소: 연관 검색어 배열
        suggestions = try container.decode([String].self)
    }
}
