//
//  VideoPlayerView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import SwiftUI
import WebKit
import RealmSwift

class VideoObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String = ""
    // URL은 직접 저장할 수 없으므로 String 형태로 저장
    @Persisted var thumbnailURL: String = ""
    
    convenience init(video: Video) {
        self.init()
        self.id = video.id
        self.title = video.title
        self.thumbnailURL = video.thumbnail.absoluteString
    }
}

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true  // 인라인 재생 허용
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // videoID를 이용해 embed URL 생성 (playsinline=1: 앱 내 재생)
        let urlString = "https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=1"
        guard let url = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: url))
    }
}

struct VideoPlayView: View {
    let video : Video
    let isAddable : Bool
    @State private var showSuccessToastMessage : Bool = false
    @State private var showErrorToastMessage : Bool = false
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                YouTubePlayerView(videoID: video.id)
                    .frame(height: 250)
                MarqueeText(
                    text: video.title,
                    font: UIFont.preferredFont(forTextStyle: .title2),
                   leftFade: 16,
                   rightFade: 16,
                   startDelay: 3,
                    fontWeight: .semibold,
                    foregroundStyle: .white
                   )
                .padding()
                if(isAddable==true){
                    Button{
                        saveVideo()
                    }label: {
                        ModifiedButtonView(text: "저장하기")
                    }
                }
                Spacer()
            }
            if (showSuccessToastMessage){
                ToastMessage(type: .saved, title: "성공", message: "저장하였습니다", onCancelTapped: {showSuccessToastMessage = false})
            }
            else   if (showErrorToastMessage){
                ToastMessage(type: .error, title: "실패", message: "에러가 발생하였습니다", onCancelTapped: {showErrorToastMessage = false})
            }
        }
        .background(GrayGradient())
    }
    func saveVideo() {
           do {
               let realm = try Realm()
               let videoObject = VideoObject(video: video)
               try realm.write {
                   realm.add(videoObject, update: .modified)
               }
               showSuccessToastMessage = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                          showSuccessToastMessage = false
                      }
           } catch {
               showErrorToastMessage = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                          showErrorToastMessage = false
                      }
           }
       }
}

//#Preview {
//    VideoPlayView()
//}
