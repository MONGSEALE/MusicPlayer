//
//  ModifiedButtonView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/5/24.
//

import SwiftUI

struct ModifiedButtonView: View {
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
//                .background(
//                    ZStack{
//                        Color(#colorLiteral(red:0.7608050108,green: 0.8164883852, blue: 0.9259157777,alpha:1))
//                        Circle()
//                            .foregroundStyle(.white)
//                            .blur(radius: 4)
//                            .offset(x: -8,y: -8)
//                        Circle()
//                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white,Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                            .padding(2)
//                            .blur(radius: 2)
//                    }
//                        .clipShape(Circle())
//                )
        
    }
}

#Preview {
    ModifiedButtonView(image: "")
}
