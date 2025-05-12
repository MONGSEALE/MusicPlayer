//
//  OnlineView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/3/25.
//

import SwiftUI

struct VideoSearchView: View {
    
    @StateObject var youtubeSearchViewModel = YouTubeSearchViewModel()
    @StateObject var youtubePlayViewModel = YoutubePlayViewModel()
    @State private var searchText = ""
    @State private var selectedVideo : Video? = nil
    @State private var showVideoPreviewView : Bool = false
    @Environment(\.dismissSearch) private var dismissSearchAction  // 검색창 닫기 함수 :contentReference[oaicite:6]{index=6}
    @State private var hideSearchDisplay : Bool = false
   
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UISearchBar.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
    }
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                VStack {
                    if youtubeSearchViewModel.isLoading {
                        Spacer()
                        ProgressView("검색중...")
                        Spacer()
                    }
                    List(youtubeSearchViewModel.videos) { video in
                        HStack(spacing: 10) {
                            // AsyncImage는 iOS 15 이상에서 지원 (썸네일 이미지 표시)
                            AsyncImage(url: video.thumbnail) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 56)
                            .clipped()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(video.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .foregroundStyle(.white)
                            }
                        }
                        .listRowBackground(Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedVideo = video
                            showVideoPreviewView = true
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("유튜브 검색")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "검색어 입력")
            .searchSuggestions {
                    ForEach(youtubeSearchViewModel.suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                            .searchCompletion(suggestion)
                    }
            }
            .onSubmit(of: .search) {
                dismissSearchAction()
                youtubeSearchViewModel.searchVideos(query: searchText)
                hideSearchDisplay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    hideSearchDisplay = false
                }
            }
            .sheet(isPresented: $showVideoPreviewView){
                VideoPreviewView(video: $selectedVideo,youtubePlayViewModel: youtubePlayViewModel,youtubeSearchViewModel: youtubeSearchViewModel)
                    .presentationDetents([.fraction(0.7)])
                    .onAppear{
                        youtubeSearchViewModel.getVideoDetail(videoID: selectedVideo?.id ?? "")
                    }
            }
            .onChange(of:showVideoPreviewView){
                if(showVideoPreviewView==false){
                    youtubePlayViewModel.player = nil
                }
            }
            .onChange(of: searchText) {
                if (hideSearchDisplay == false){
                    youtubeSearchViewModel.suggestions = []
                    let current = searchText
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if current == searchText {
                            youtubeSearchViewModel.getSeggestion(query: current)
                        }
                    }
                }
            }
          

        }
    }
}

//#Preview {
//    VideoSearchView()
//}
