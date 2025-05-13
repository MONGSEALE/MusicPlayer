//
//  PlayListView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/1/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var youtubeSearchViewModel = YouTubeSearchViewModel()
    @StateObject var youtubePlayViewModel = YoutubePlayViewModel()
    @State var selectedPlaylist : Playlist? = nil
    @State private var toVideoSearchView : Bool = false
    @State var toPlaylistView : Bool = false
    @State var showVideoPreviewView: Bool = false
    @State var selectedSong: Video? = nil
    @State private var toTopSongsView : Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                GrayGradient()
                    .ignoresSafeArea()
                VStack {
                    HStack{
                        Text("홈")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding(.leading)
                        Spacer()
                        Button{
                            toVideoSearchView = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                        .padding(.trailing)
                    }
                    
                    ScrollView{
                        
                        VStack(spacing:0){
                            HStack{
                                Text("새 앨범 및 싱글")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .padding(.leading)
                                Spacer()
                            }
                            PlayListScrollView(selectedPlaylist: $selectedPlaylist, toPlaylistView: $toPlaylistView,query: "Korean new album")
                        }
                        .padding(.vertical)
                        
                        VStack(spacing:0){
                            HStack{
                                Text("봄 플레이리스트")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .padding(.leading)
                                Spacer()
                            }
                            PlayListScrollView(selectedPlaylist: $selectedPlaylist, toPlaylistView: $toPlaylistView, query: "봄 플레이리스트")
                        }
                        .padding(.vertical)
                        
                        VStack(spacing:0){
                            HStack{
                                Text("에너지 충전")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .padding(.leading)
                                Spacer()
                            }
                            PlayListScrollView(selectedPlaylist: $selectedPlaylist, toPlaylistView: $toPlaylistView, query: "신나는")
                        }
                        .padding(.vertical)
                        
                        VStack{
                            HStack{
                                Text("인기곡 30")
                                    .padding(.leading)
                                Spacer()
                                Image(systemName: "arrow.forward")
                                    .foregroundStyle(.white)
                                    .padding(.trailing)
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .font(.title2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toTopSongsView = true
                            }
                            
                            MusicCollectionView(youtubeSearchViewModel:youtubeSearchViewModel,selectedSong: $selectedSong, showVideoPreviewView: $showVideoPreviewView)
                            
                            Spacer()
                                   .frame(height: 300)
                            
                        }
                        .padding(.vertical)
                       
                        
                    }
                }
            }
            .navigationDestination(isPresented: $toPlaylistView, destination: {PlayListView(playlist: selectedPlaylist,youtubeSearchViewModel: youtubeSearchViewModel,youtubePlayViewModel: youtubePlayViewModel)})
            .navigationDestination(isPresented: $toVideoSearchView, destination: {VideoSearchView()})
            .navigationDestination(isPresented: $toTopSongsView, destination: {TopSongsView(youtubeSearchViewModel: youtubeSearchViewModel,youtubePlayViewModel: youtubePlayViewModel)})
        }
        .sheet(isPresented:$showVideoPreviewView){
            VideoPreviewView(video: $selectedSong,youtubePlayViewModel: youtubePlayViewModel,youtubeSearchViewModel: youtubeSearchViewModel)
                .presentationDetents([.fraction(0.8)])
                .onAppear{
                    youtubeSearchViewModel.getVideoDetail(videoID: selectedSong?.id ?? "")
                }
        }
    }
}

//#Preview {
//    HomeView()
//}


struct PlayListScrollView: View {
    @StateObject var youtubeSearchViewModel = YouTubeSearchViewModel()
    @Binding var selectedPlaylist: Playlist?
    @Binding var toPlaylistView: Bool
    let query : String
    @State private var openFirst : Bool = true
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(Array(youtubeSearchViewModel.playlists.enumerated()), id: \.element) { index, playlist in
                    VStack(spacing: 4) {
                        AsyncImage(url: playlist.thumbnail) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Color.red
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(playlist.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(playlist.channelTitle)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .frame(width: 100)
                    // 첫 번째 요소에는 왼쪽 패딩, 마지막 요소에는 오른쪽 패딩 적용
                    .padding(.leading, index == 0 ? 16 : 0)
                    .padding(.trailing, index == youtubeSearchViewModel.playlists.count - 1 ? 16 : 0)
                    .onAppear {
                        youtubeSearchViewModel.updateVideosForPlaylist(playlist: playlist)
                    }
                    .onTapGesture {
                        selectedPlaylist = playlist
                        toPlaylistView = true
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear{
            if (openFirst == true){
                youtubeSearchViewModel.getPlaylist(query: query)
             //   youtubeSearchViewModel.getPlaylistDummyData()
                openFirst = false
            }
        }
    }
}

struct MusicCollectionView: View {
    @ObservedObject var youtubeSearchViewModel = YouTubeSearchViewModel()
    @Binding var selectedSong: Video?
    @Binding var showVideoPreviewView: Bool
    @State private var openFirst : Bool = true

    // topSongs를 4개씩 그룹화한 배열
    var chunkedSongs: [[Video]] {
        Array(youtubeSearchViewModel.topSongs.prefix(12)).chunked(into: 4)
    }

    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(chunkedSongs.enumerated()), id: \.element) { groupIndex, songGroup in
                        VStack(spacing: 0) {
                            ForEach(Array(songGroup.enumerated()), id: \.element.id) { songIndex, song in
                                // 전체 순위 계산 
                                let rank = groupIndex * 4 + songIndex + 1
                                MusicCell(video: song, rank: rank)
                                    .onTapGesture {
                                        selectedSong = song
                                        showVideoPreviewView = true
                                    }
                            }
                            // 그룹 내에 4개 미만이면, 빈 공간으로 채워서 정렬 유지
                            if songGroup.count < 4 {
                                ForEach(0..<(4 - songGroup.count), id: \.self) { _ in
                                    Spacer()
                                        .frame(height: 80)
                                }
                            }
                        }
                        .frame(width: proxy.size.width) // 각 페이지가 전체 화면 너비를 차지
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onAppear {
                if(openFirst == true){
                    youtubeSearchViewModel.getTop50Songs()
                    openFirst = false
                }
            }
        }
    }
}




extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { index in
            Array(self[index..<Swift.min(index + size, count)])
        }
    }
}
