//
//  ModifiedButtonView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/5/24.
//

import SwiftUI

struct PlayButtonView: View {
    var image : String
    var body: some View {
            Image(systemName: image)
                .font(.system(size: 14,weight: .bold))
                .padding(.all,25)
                .foregroundStyle(.black.opacity(0.8))
                .background(
                    ZStack{
                        Circle()
                            .fill(.white.opacity(0.9))
                    }
                )
    }
}

#Preview {
    PlayButtonView(image: "")
}
