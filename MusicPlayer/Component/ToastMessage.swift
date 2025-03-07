//
//  ToastMessage.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/7/25.
//

import SwiftUI

enum FancyToastStyle {
    case error
    case saved
}

extension FancyToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .saved: return Color.green
        }
    }
    
    var iconFileName: String {
        switch self {
//        case .info: return "info.circle.fill"
//        case .warning: return "exclamationmark.triangle.fill"
        case .saved: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

struct ToastMessage: View {
    var type: FancyToastStyle
      var title: String
      var message: String
      var onCancelTapped: (() -> Void)
      var body: some View {
          VStack(alignment: .leading) {
              HStack(alignment: .top) {
                  Image(systemName: type.iconFileName)
                      .foregroundColor(type.themeColor)
                  
                  VStack(alignment: .leading) {
                      Text(title)
                          .font(.system(size: 14, weight: .semibold))
                      
                      Text(message)
                          .font(.system(size: 12))
                          .foregroundColor(Color.black.opacity(0.6))
                  }
                  
                  Spacer(minLength: 10)
                  
                  Button {
                      onCancelTapped()
                  } label: {
                      Image(systemName: "xmark")
                          .foregroundColor(Color.black)
                  }
              }
              .padding()
          }
          .background(Color.white)
          .overlay(
              Rectangle()
                  .fill(type.themeColor)
                  .frame(width: 6)
                  .clipped()
              , alignment: .leading
          )
          .frame(minWidth: 0, maxWidth: .infinity)
          .cornerRadius(8)
          .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
          .padding(.horizontal, 16)
      }
}

#Preview {
    ToastMessage(type: .saved, title: "아나", message: "ㅇㄴㄴㅇ", onCancelTapped: {})
}
