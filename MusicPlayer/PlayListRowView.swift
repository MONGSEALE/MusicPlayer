//
//  SongListRowView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/5/24.
//

import SwiftUI

//이미지 파일 크기는 반드시 736x485

struct PlayListRowView: View {
    let imageName: String
    let title: String
    let artist: String
    let duration : TimeInterval?
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                HStack{
                    Text(artist)
                    Text(formatDuration(duration))
                }
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.vertical)
    }
    private func formatDuration(_ duration: TimeInterval?) -> String {
           guard let duration = duration else { return "00:00" }
           let minutes = Int(duration) / 60
           let seconds = Int(duration) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
}




#Preview {
    PlayListRowView(imageName:"케이시",title: "아무말도 할 수 없는 나인데",artist: "케이시", duration: 0.0)
}
