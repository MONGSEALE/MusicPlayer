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
    @State private var bottomSheetHeight: CGFloat? = 80
    @State private var selectedSong : SongModel = dummyData[0]
   
    var body: some View {
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
                .padding(.bottom,80)
            BottomSheet(currentSong: $currentSong, song: $selectedSong, currentHeight: $bottomSheetHeight)
                .frame(height: bottomSheetHeight)  
                .edgesIgnoringSafeArea(.all)
        }
        .onChange(of:currentSong){
            selectedSong = SongDatas[currentSong ?? 0]
        }
    }
    

}

#Preview {
    MusicListView( )
}

struct BottomSheet: UIViewControllerRepresentable {
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
            hostingController.rootView = MusicPlayerView(currentSongIndex: uiViewController.currentSongIndexBinding ,song: Binding<SongModel?>(
                   get: { uiViewController.song },
                   set: { uiViewController.song = $0 }
            ),currentHeight: uiViewController.currentHeightBinding)
           }
    }
}
