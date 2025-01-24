//
//  LoadingView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/6/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
      
        VStack(spacing:10){
                Text("노래 불러오는중 ... 아 삼겹살 먹고싶다")
                ProgressView()
            }
        .fontWeight(.semibold)
        .padding()
        .background(Color.gray.opacity(0.6))
        .cornerRadius(10)
        
    }
}

#Preview {
    LoadingView()
}
