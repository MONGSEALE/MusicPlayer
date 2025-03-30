//
//  FormattedCount.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation


func formattedCount(_ count: Int?) -> String {
    guard let count = count else { return "0" }
    if count >= 10000 {
        let value = count / 10000
        return "\(value)만"
    }
    return "\(count)"
}
