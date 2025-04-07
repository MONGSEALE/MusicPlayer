//
//  FormattedCount.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation


func formattedCount(_ count: Int?) -> String {
    guard let count = count else { return "0" }
    
    if count >= 100_000_000 {
        let value = Double(count) / 100_000_000.0
        return String(format: "%.1f억", value)
    } else if count >= 10_000 {
        let value = Double(count) / 10_000.0
        return String(format: "%.0f만", value)
    }
    return "\(count)"
}

