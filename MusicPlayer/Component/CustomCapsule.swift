//
//  CustomTextCapsule.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/30/25.
//

import Foundation
import SwiftUI

struct CustomCapsule: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal)
            .background(CapsuleColor())
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func customCapsule() -> some View {
        self.modifier(CustomCapsule())
    }
}
