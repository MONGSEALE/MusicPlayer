//
//  PlayListView2.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/1/25.
//

import SwiftUI

struct PlayListView: View {
    let playlist : Playlist?
    @State private var showVideoPreviewView : Bool = false
    @State private var selectedVideo : Video? = nil
    @ObservedObject var youtubeSearchViewModel = YouTubeSearchViewModel()
    @ObservedObject var youtubePlayViewModel = YoutubePlayViewModel()
    
    var body: some View {
        ZStack{
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
        
                ScrollView{
                    HStack{
                        Text(playlist?.title ?? "")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    .padding(.horizontal)
                    if let videos = playlist?.videos{
                        ForEach(videos){ video in
                            HStack(spacing: 10) {
                                // AsyncImage는 iOS 15 이상에서 지원 (썸네일 이미지 표시)
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
                                .padding(.horizontal)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(video.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundStyle(.white)
                                    Text(video.channelTitle)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .onTapGesture {
                                selectedVideo = video
                                showVideoPreviewView = true
                            }
                        }
                    }
                }
            
        }
        .sheet(isPresented: $showVideoPreviewView){
            VideoPreviewView(video: $selectedVideo,youtubePlayViewModel: youtubePlayViewModel,youtubeSearchViewModel: youtubeSearchViewModel)
                .presentationDetents([.fraction(0.8)])
                .onAppear{
                    youtubeSearchViewModel.getVideoDetail(videoID: selectedVideo?.id ?? "")
                }
        }
    }
}

//#Preview {
//    PlayListView(videos: dummyVideos,youtubeSearchViewModel: YouTubeSearchViewModel(), youtubePlayViewModel: YoutubePlayViewModel())
//}

let dummyVideos: [Video] = [
    Video(id: "video1", title: "Dummy Video 1", thumbnail: URL(string: "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")!, channelTitle: "Channel 1"),
    Video(id: "video2", title: "Dummy Video 2", thumbnail: URL(string: "https://i.ytimg.com/vi/3JZ_D3ELwOQ/mqdefault.jpg")!, channelTitle: "Channel 2"),
    Video(id: "video3", title: "Dummy Video 3", thumbnail: URL(string: "https://i.ytimg.com/vi/tVj0ZTS4WF4/mqdefault.jpg")!, channelTitle: "Channel 3"),
    Video(id: "video4", title: "Dummy Video 4", thumbnail: URL(string: "https://i.ytimg.com/vi/2vjPBrBU-TM/mqdefault.jpg")!, channelTitle: "Channel 4"),
    Video(id: "video5", title: "Dummy Video 5", thumbnail: URL(string: "https://i.ytimg.com/vi/kJQP7kiw5Fk/mqdefault.jpg")!, channelTitle: "Channel 5"),
    Video(id: "video6", title: "Dummy Video 6", thumbnail: URL(string: "https://i.ytimg.com/vi/CevxZvSJLk8/mqdefault.jpg")!, channelTitle: "Channel 6"),
    Video(id: "video7", title: "Dummy Video 7", thumbnail: URL(string: "https://i.ytimg.com/vi/9bZkp7q19f0/mqdefault.jpg")!, channelTitle: "Channel 7")
]
