//
//  VideoListView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import SwiftUI
import RealmSwift

struct VideoListView: View {
    @ObservedResults(VideoObject.self) var videos
    @State private var toVideoSearchView : Bool = false
    @State private var selectedVideo : Video? = nil
    var convertedVideos: [Video] {
        videos.map { Video(from: $0) }
    }
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                List {
                    ForEach(convertedVideos) { video in
                        HStack(spacing: 10) {
                            AsyncImage(url: video.thumbnail) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 56)
                            .clipped()
                            Text(video.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        .listRowBackground(Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)))
                        .onTapGesture {
                            selectedVideo = video
                        }
                        .sheet(item: $selectedVideo) { video in
                            VideoPlayView(video: video,isAddable: false)
                                .presentationDetents([.fraction(0.5)])
                        }
                    }
                    .onDelete(perform: $videos.remove)
                }
                .scrollContentBackground(.hidden)
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            toVideoSearchView = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 60, height: 60)
                                )
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("저장된 영상")
//            .toolbar {
//                EditButton()
//            }
            .navigationDestination(isPresented: $toVideoSearchView, destination: {VideoSearchView()})
        }
    }
}

extension Video {
    init(from object: VideoObject) {
        self.id = object.id
        self.title = object.title
        self.thumbnail = URL(string: object.thumbnailURL) ?? URL(string:"https://")!
    }
}


#Preview {
    VideoListView()
}
