//
//  YoutubeSearchViewModel.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import Foundation

class YouTubeSearchViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var videoDetail: VideoDetail?
    
    private let apiKey = "AIzaSyB81R-wQ4SPckDeFHA2c2weg0OiRQM4_ro"
    
    func fetchVideos(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        // API 키를 발급받아 여기에 입력하세요.
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(encodedQuery)&type=video&maxResults=20&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            guard let data = data, error == nil else {
                print("네트워크 오류: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(YouTubeAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.videos = apiResponse.items
                }
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
    }
    
    func getVideoDetail(videoID: String) {

        let urlString = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=\(videoID)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("네트워크 오류: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // API 응답값이 items 배열에 담겨있으므로 VideoDetailResponse로 디코딩
                let detailResponse = try JSONDecoder().decode(VideoDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    self.videoDetail = detailResponse.items.first
                }
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
    }
}

