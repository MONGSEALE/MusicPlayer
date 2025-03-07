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
    
    func fetchVideos(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        // API 키를 발급받아 여기에 입력하세요.
        let apiKey = "AIzaSyB81R-wQ4SPckDeFHA2c2weg0OiRQM4_ro"
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(encodedQuery)&type=video&maxResults=10&key=\(apiKey)"
        
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
}

