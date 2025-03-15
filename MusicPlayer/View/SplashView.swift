//
//  SplashView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/12/25.
//

import SwiftUI
import RealmSwift

struct SplashView: View {
    @ObservedObject var youtubePlayViewModel : YoutubePlayViewModel
    @ObservedResults(VideoObject.self) var videos
    @Binding var isSplashOn : Bool
    var convertedIDs: [String] {
        videos.map { Video(from: $0).id }
    }
    @State private var isAnimating = false

    var body: some View {
        VStack{
            Spacer()
            VStack(spacing:50){
                BookPagesView(animationStarted: .constant(true), animationDuration: 0.5)
                Text("저장한 음악 가져오는중...")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
                .frame(maxWidth: .infinity, maxHeight: 200)
            Spacer()
        }
        .background(GrayGradient())
        .ignoresSafeArea()
        .borderLoadingAnimation(isAnimating: $isAnimating)
        .onAppear{
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                          isAnimating = true
                      }
            Task{
                isSplashOn = true
                await youtubePlayViewModel.extractAndStoreVideos(videoIDs: convertedIDs)
                isSplashOn = false
            }
        }
    }
}


#Preview {
    SplashView(youtubePlayViewModel : YoutubePlayViewModel(),isSplashOn: .constant(true) )
}

extension View {
    func borderLoadingAnimation(isAnimating: Binding<Bool>) -> some View {
        modifier(BorderLoadingAnimation(isAnimating: isAnimating))
    }
}

struct BorderLoadingAnimation: ViewModifier, Animatable {
    @Binding var isAnimating: Bool
    
    private let lineWidth: CGFloat = 5
    @State private var hasTopSafeAreaInset: Bool = false

    var animatableData: Bool {
        get { isAnimating }
        set { isAnimating = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: hasTopSafeAreaInset ? 0 : 52)
                        .stroke(
                            AngularGradient(
                                stops: [
                                    .init(color: .black, location: 0),
                                    .init(color: .cyan, location: 0.1),
                                    .init(color: .cyan, location: 0.4),
                                    .init(color: .black, location: 0.5)
                                ],
                                center: .center,
                                angle: .degrees(isAnimating ? 360 : 0)
                            ),
                            lineWidth: lineWidth
                        )
                        .frame(width: geometry.size.width - lineWidth, height: geometry.size.height - lineWidth)
                        .padding(.top, lineWidth / 2)
                        .padding(.leading, lineWidth / 2)
                        .onAppear {
                            let topSafeAreaInset = geometry.safeAreaInsets.top
                            hasTopSafeAreaInset = topSafeAreaInset > 20
                        }
                }
            )
            .ignoresSafeArea()
    }
}
