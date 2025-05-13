//
//  CustomTextCapsule.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation
import SwiftUI

struct CustomCapsule: ViewModifier {
    let font : Font
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(.white)
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func customCapsule() -> some View {
        self.modifier(CustomCapsule(font: .caption))
    }
}


