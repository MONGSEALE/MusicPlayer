//
//  MainView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/3/25.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @ObservedResults(VideoObject.self) var videos
    var convertedIDs: [String] {
        videos.map { Video(from: $0).id }
    }

    init(youtubePlayViewModel : YoutubePlayViewModel) {
        // UITabBarAppearance를 이용한 커스텀
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 원하는 배경색 설정 (예: 어두운 회색)
        appearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // 일반 상태의 아이콘, 텍스트 색상 설정 (예: 흰색)
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // 선택된 상태의 아이콘, 텍스트 색상 설정 (예: 시안색)
        appearance.stackedLayoutAppearance.selected.iconColor = .cyan
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.cyan]
        
        // 설정 적용
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        self.youtubePlayViewModel = youtubePlayViewModel
    }
    var body: some View {
        TabView {
            MusicListView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("음악")
                }
            
            VideoListView(youtubePlayViewModel: youtubePlayViewModel)
                .tabItem {
                    Image(systemName: "video")
                    Text("영상")
                }
        }
//        .onAppear{
//            Task{
//                print("extractVideos 함수 실행")
//              await youtubePlayViewModel.extractVideos(videoIDs: convertedIDs)
//                print("extractVideos 함수 완료됨")
//            }
//        }
    }
}





#Preview {
    MainView(youtubePlayViewModel: YoutubePlayViewModel())
}
