//
//  GrayGradient.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import Foundation
import SwiftUI

struct GrayGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.3, green: 0.3, blue: 0.3), // 상단: 좀 더 밝음
                Color(red: 0.15, green: 0.15, blue: 0.2), // 중간
                Color(red: 0.05, green: 0.05, blue: 0.05)  // 하단: 어둡게
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}



