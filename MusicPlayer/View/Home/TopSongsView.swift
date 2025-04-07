//
//  TopSongsView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/4/25.
//

import SwiftUI

struct TopSongsView: View {
    @ObservedObject var youtubeSearchViewModel : YouTubeSearchViewModel
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @State private var showVideoPreviewView : Bool = false
    @State private var selectedVideo : Video? = nil
    var body: some View {
        ZStack{
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            VStack{
                ScrollView(.vertical,showsIndicators: false){
                    Text("국내 인기곡 Top30")
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundStyle(.white)
                 
                        ForEach(Array(youtubeSearchViewModel.topSongs.enumerated()), id: \.element) { index, song in
                            MusicCell(video: song, rank: index + 1)
                                .onTapGesture {
                                    selectedVideo = song
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

#Preview {
    TopSongsView(youtubeSearchViewModel: YouTubeSearchViewModel(),youtubePlayViewModel: YoutubePlayViewModel())
}
