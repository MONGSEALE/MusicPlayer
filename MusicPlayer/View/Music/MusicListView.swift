//
//  MusicListView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/3/25.
//

import SwiftUI
import AVFAudio

struct MusicListView: View {
    let SongDatas : [SongModel] = dummyData
    @State var currentSong : Int? = 0
    @State private var bottomSheetHeight: CGFloat? = 100
    @State private var selectedSong : SongModel = dummyData[0]
    private let sheetTotalHeight = UIScreen.main.bounds.height * 0.8
    // Blur 추가함수
    var computedBlur: CGFloat {
        let minHeight: CGFloat = 100
        let maxBlur: CGFloat = 4        // 최대 blur 효과
        guard bottomSheetHeight ?? 100 > minHeight else { return 0 }
        
        // 진행률을 0~1로 계산한 뒤, 비선형(easing) 함수를 적용
        let normalized = (bottomSheetHeight ?? 100 - minHeight) / (sheetTotalHeight - minHeight)
        let easedProgress = pow(normalized, 2)  // 제곱함수: 초반 변화는 느리게, 후반부는 빠르게
        return maxBlur * easedProgress
    }
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 네비게이션 타이틀 텍스트 색상 설정
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        // 네비게이션 배경색을 회색으로 설정
        appearance.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                ScrollView{
                    VStack(spacing:0){
                        ForEach(SongDatas.indices, id: \.self) { index in
                            let song = SongDatas[index]
                            MusicListRowView(imageName: song.imageName, title: song.title, artist: song.artist,duration: song.duration)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    currentSong = index
                                }
                                .background(currentSong == index ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color(red: 0.2, green: 0.2, blue: 0.2))
                        }
                    }
                }
                .padding(.bottom,100)
                .blur(radius: computedBlur)
                .allowsHitTesting(bottomSheetHeight ?? 100 == 100 )
                BottomMusicSheet(currentSong: $currentSong, song: $selectedSong, currentHeight: $bottomSheetHeight)
                    .frame(height: bottomSheetHeight)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("저장된 음악")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of:currentSong){
                selectedSong = SongDatas[currentSong ?? 0]
            }
        }
    }
    
}

#Preview {
    MusicListView( )
}

struct BottomMusicSheet: UIViewControllerRepresentable {
    @Binding var currentSong: Int?
    @Binding var song: SongModel
    @Binding var currentHeight: CGFloat?   // 새로 추가한 바인딩
    
    func makeUIViewController(context: Context) -> BottomSheetViewController {
        let vc = BottomSheetViewController()
        vc.song = song
        vc.currentSongIndexBinding = $currentSong
        vc.currentHeightBinding = $currentHeight   // 바인딩 전달
        return vc
    }
    
    
    func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        uiViewController.song = song
        uiViewController.currentSongIndexBinding = $currentSong
        uiViewController.currentHeightBinding = $currentHeight
        if let hostingController = uiViewController.hostingController {
            hostingController.rootView = MusicPlayView(currentSongIndex: uiViewController.currentSongIndexBinding ,song: Binding<SongModel?>(
                get: { uiViewController.song },
                set: { uiViewController.song = $0 }
            ),currentHeight: uiViewController.currentHeightBinding)
        }
    }
}
