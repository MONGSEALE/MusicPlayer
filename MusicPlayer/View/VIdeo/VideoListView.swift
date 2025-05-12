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
    @State var selectedVideo : Video? = nil
    @State private var startingOffset: CGFloat = UIScreen.main.bounds.height * 0.7
    @State private var currentOffset:CGFloat = 0
    @State private var endOffset:CGFloat = 0
    @State var index : Int = 0
    @State private var maxIndex : Int = 0
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @StateObject var youtubeSearchViewModel  = YouTubeSearchViewModel()
    @State private var youtubeURL : URL? = nil
    var convertedVideos: [Video] {
        videos.map { Video(from: $0) }
    }
    init(youtubePlayViewModel : YoutubePlayViewModel) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        self.youtubePlayViewModel = youtubePlayViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom){

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
                        
                            VStack(alignment:.leading){
                     
                                    Text(video.title)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                        .truncationMode(.tail)

                                    Text(video.channelTitle)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                   
                            }
                            Spacer()
                        }
                        .onTapGesture {
                            selectedVideo = video
                            if let selectedIndex = convertedVideos.firstIndex(where: { $0.id == video.id }) {
                                index = selectedIndex
                            }
                        }
                        .listRowBackground(video == selectedVideo ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color(red: 0.2, green: 0.2, blue: 0.2)
                        )
                        
                    }
                    .onDelete(perform: $videos.remove)
                    ZStack{
    
                    }
                    .frame(height: 80)
                    .listRowBackground(Color(red: 0.2, green: 0.2, blue: 0.2)
                    )
                      
                }
                .listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                if (selectedVideo != nil){
                    VideoPlayView(video: $selectedVideo,startingOffset: $startingOffset,currentOffset: $currentOffset,endOffset: $endOffset,youtubePlayViewModel: youtubePlayViewModel,index : $index,maxIndex: $maxIndex,youtubeURL:$youtubeURL,youtubeSearchViewModel:youtubeSearchViewModel)
                        .background(GrayGradient())
                        .offset(y:startingOffset)
                        .offset(y:currentOffset)
                        .offset(y:endOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.spring()) {
                                        // 기본 상태일 때 아래로 드래그하지 못하게 함
                                        if endOffset == 0 && value.translation.height > 0 {
                                            currentOffset = 0
                                        }
                                        // sheet가 완전히 열린 상태일 때 위로 드래그가 더 적용되지 않도록 함
                                        else if endOffset == -startingOffset && value.translation.height < 0 {
                                            currentOffset = 0
                                        } else {
                                            currentOffset = value.translation.height
                                        }
                                    }
                                }
                                .onEnded{ value in
                                    withAnimation(.spring()){
                                        if currentOffset < -150{
                                            endOffset = -startingOffset
                                        }else if endOffset != 0 && currentOffset > 150 {
                                            endOffset = .zero
                                        }
                                        currentOffset = 0
                                    }
                                }
                        )
                }
            }
            .navigationTitle("저장된 영상")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                maxIndex = convertedVideos.count - 1
            }
            .onChange(of:convertedVideos){
                maxIndex = convertedVideos.count - 1
                if let selected = selectedVideo,
                   let foundIndex = convertedVideos.firstIndex(where: { $0.id == selected.id }) {
                    index = foundIndex
                } else {
                    index = 0 // 선택된 비디오가 없을 경우 기본값 할당
                }
            }
            .onChange(of:index){
                selectedVideo = convertedVideos[index]
            }
            .onChange(of:selectedVideo){
                youtubePlayViewModel.player = nil
                youtubeSearchViewModel.videoDetail = nil
                Task{
                    guard let selectedVideo = selectedVideo else { return }
                    youtubePlayViewModel.setVideoPlayer(videoID: selectedVideo.id)
                    youtubeSearchViewModel.getVideoDetail(videoID: selectedVideo.id)
                    youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(selectedVideo.id)")
                }
            }
            .onDisappear{
                youtubePlayViewModel.player?.pause()
            }
        }
    }
}

extension Video {
    init(from object: VideoObject) {
        self.id = object.id
        self.title = object.title
        self.thumbnail = URL(string: object.thumbnailURL) ?? URL(string:"https://")!
        self.channelTitle = object.channelTitle
    }
}


//#Preview {
//    VideoListView()
//}
