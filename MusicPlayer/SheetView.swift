//
//  SheetView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/30/24.
//

import SwiftUI

enum SheetFilter : Int ,CaseIterable,Identifiable  {
    case track
    case lyrics
    var title : String {
        switch self{
        case.track: return "다음 트랙"
        case.lyrics: return "가사"
        }
    }
    var id : Int {
        return self.rawValue
    }
}

struct SheetView: View {
    private var filterWidth: CGFloat {
        let count = CGFloat(SheetFilter.allCases.count)
        let additionalWidth = UIScreen.main.bounds.width * 0.45
        return (UIScreen.main.bounds.width / count) + additionalWidth
    }
    @State var tabIndex = 0
    @State private var selectedFilter : SheetFilter = .track
    @Namespace var animation
    private var topPadding: CGFloat {
           return UIScreen.main.bounds.height * 0.05 // 전체 높이의 5%를 상단 패딩으로 사용
       }
    var body: some View {
        VStack{
            HStack {
                   Text("다음 트랙")
                    .frame(width: filterWidth/2)
                       .onTapGesture {
                           withAnimation(.spring()) {
                               selectedFilter = .track
                           }
                       }
                   Text("가사")
                    .frame(width: filterWidth/2)
                       .onTapGesture {
                           withAnimation(.spring()) {
                               selectedFilter = .lyrics
                           }
                       }
               }
            ZStack(alignment: .leading) {
                           Rectangle()
                               .foregroundStyle(.gray)
                               .frame(width: filterWidth, height: 1)
                           Rectangle()
                               .foregroundStyle(.black)
                               .frame(width: filterWidth / CGFloat(SheetFilter.allCases.count), height: 1)
                               .offset(x: selectedFilter == .track ? 0 : filterWidth / 2)
                               .matchedGeometryEffect(id: "item", in: animation)
                       }
            if(selectedFilter == .track){
                TrackView()
            }
            else{
                LyricsView()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.top,topPadding)
    }
}

struct TrackView: View{
    var body: some View{
        ZStack{
            Color.green
            ScrollView{
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
                Text("다음 트랙")
            }
            .font(.largeTitle)
        }
        .ignoresSafeArea()
    }
}

struct LyricsView: View{
    var body: some View{
        ZStack{
            Color.orange
            ScrollView{
                Spacer()
                Text("가사")
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SheetView()
}
