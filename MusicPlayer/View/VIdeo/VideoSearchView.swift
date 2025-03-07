//
//  OnlineView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/3/25.
//

import SwiftUI

struct VideoSearchView: View {
    @StateObject var viewModel = YouTubeSearchViewModel()
    @State private var searchText = ""
    @State private var selectedVideo : Video? = nil
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
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("검색중...")
                        Spacer()
                    }
                    List(viewModel.videos) { video in
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
                        }
                        .sheet(item: $selectedVideo) { video in
                            VideoPlayView(video: video,isAddable: true)
                                .presentationDetents([.fraction(0.6)])
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("유튜브 검색")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "검색어 입력")

            .onSubmit(of: .search) {
                viewModel.fetchVideos(query: searchText)
            }
        }
    }
}

#Preview {
    VideoSearchView()
}
