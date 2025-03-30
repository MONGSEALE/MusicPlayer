//
//  CapsuleColor.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation
import SwiftUI

struct CapsuleColor: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.3, green: 0.3, blue: 0.3),
                Color(red: 0.15, green: 0.15, blue: 0.2),
                Color(red: 0.05, green: 0.05, blue: 0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

