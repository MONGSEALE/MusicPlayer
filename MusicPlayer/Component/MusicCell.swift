//
//  VideoCell.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/3/25.
//

import SwiftUI

struct MusicCell: View {
    let video : Video
    let rank : Int
    var body: some View {
        HStack {
            VStack(spacing:0){
                Text(String(rank))
                    .font(.system(size: 28, weight: .semibold))
                Text("•")
            }
            .frame(width: 40)
            .foregroundStyle(.white)
            AsyncImage(url: video.thumbnail) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .clipped()
            
            VStack{
                HStack{
                    Text(video.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                HStack{
                    Text(video.channelTitle)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                
            }
            .padding(.leading)
            Spacer()
        }
        .padding(8)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    MusicCell(video: Video(id: "212", title: "211", thumbnail:URL(string: "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")! , channelTitle: "21213"),rank: 4)
}
