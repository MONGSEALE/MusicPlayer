//
//  YoutubeSearchViewModel.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/4/25.
//

import Foundation
import UIKit   // NSAttributedString을 사용하기 위해 필요

class YouTubeSearchViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var videoDetail: VideoDetail?
    @Published var playlists: [Playlist] = []
    @Published var topSongs: [Video] = []
    @Published var suggestions : [String] = []
    
    private let apiKey = "AIzaSyB81R-wQ4SPckDeFHA2c2weg0OiRQM4_ro"
    
    func searchVideos(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
      
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
                let apiResponse = try JSONDecoder().decode(YouTubeAPIVideoResponse.self, from: data)
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
    
    func getPlaylist(query: String) {
          guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
          // type=playlist를 통해 플레이리스트 검색
//          let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(encodedQuery)&type=playlist&maxResults=8&key=\(apiKey)"
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(encodedQuery)&type=playlist&maxResults=8&regionCode=KR&relevanceLanguage=ko&key=\(apiKey)"

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
              
              if let jsonString = String(data: data, encoding: .utf8) {
                         print("API 응답 JSON: \(jsonString)")
                     }
              do {
                  let apiResponse = try JSONDecoder().decode(YouTubeAPIPlaylistResponse.self, from: data)
                  DispatchQueue.main.async {
                      self.playlists = apiResponse.items
                  }
              } catch {
                  print("디코딩 오류: \(error)")
              }
          }.resume()
      }
    
    func getPlaylistDummyData() {
        let dummyPlaylists = [
            Playlist(
                id: "dummy1",
                title: "Dummy Playlist 1",
                description: "This is a dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 1",
                videos: nil
            ),
            Playlist(
                id: "dummy2",
                title: "Dummy Playlist 2",
                description: "Another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 2",
                videos: nil
            ),
            Playlist(
                id: "dummy3",
                title: "Dummy Playlist 3",
                description: "Yet another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 3",
                videos: nil
            ),
            Playlist(
                id: "dummy4",
                title: "Dummy Playlist 3",
                description: "Yet another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 4",
                videos: nil
            ),
            Playlist(
                id: "dummy5",
                title: "Dummy Playlist 3",
                description: "Yet another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 5",
                videos: nil
            ),
            Playlist(
                id: "dummy6",
                title: "Dummy Playlist 3",
                description: "Yet another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 6",
                videos: nil
            ),
            Playlist(
                id: "dummy7",
                title: "Dummy Playlist 3",
                description: "Yet another dummy playlist description.",
                thumbnail: URL(string: "https://dummyimage.com/100x100/000/fff")!,
                channelTitle: "Dummy Channel 7",
                videos: nil
            )
        ]
        
        DispatchQueue.main.async {
            self.playlists = dummyPlaylists
        }
    }
    
    func getTop50Songs() {
        let urlString = "https://www.googleapis.com/youtube/v3/videos?chart=mostPopular&regionCode=KR&videoCategoryId=10&maxResults=50&part=snippet&hl=ko&key=\(apiKey)"

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
                let decodedResponse = try JSONDecoder().decode(YouTubeAPIVideoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.topSongs = decodedResponse.items
                }
            } catch {
                print("getTop50Songs 디코딩 오류: \(error)")
            }
        }.resume()
    }

    
    func updateVideosForPlaylist(playlist: Playlist) {
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlist.id)&maxResults=10&key=\(apiKey)"
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
                let response = try JSONDecoder().decode(PlaylistItemsResponse.self, from: data)
                let videos: [Video] = response.items.compactMap { item in
                    return Video(
                        id: item.snippet.resourceId.videoId,
                        title: item.snippet.title,
                        thumbnail: URL(string: item.snippet.thumbnails.medium.url) ?? URL(string: "https://")!,
                        channelTitle: item.snippet.channelTitle
                    )
                }
                DispatchQueue.main.async {
                    if let index = self.playlists.firstIndex(where: { $0.id == playlist.id }) {
                        self.playlists[index].videos = videos
                    }
                }
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
    }
    
    func getSeggestion(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        // 비공식 연관 검색어 엔드포인트 사용
        let urlString = "https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=\(encodedQuery)"
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            if let error = error {
                print("네트워크 오류: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("데이터가 없습니다.")
                return
            }
            
            // 응답의 HTTP 상태 코드, MIME 타입, 헤더 출력
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP 상태 코드: \(httpResponse.statusCode)")
                print("MIME 타입: \(httpResponse.mimeType ?? "없음")")
                print("헤더: \(httpResponse.allHeaderFields)")
            }
            
            // EUC-KR 인코딩으로 문자열로 변환
            let eucKREncodingValue = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
            let eucKREncoding = String.Encoding(rawValue: eucKREncodingValue)
            if let responseString = String(data: data, encoding: eucKREncoding) {
                print("Raw response (EUC-KR): \(responseString)")
                
                // 문자열을 다시 UTF-8 데이터로 변환
                if let utf8Data = responseString.data(using: .utf8) {
                    do {
                        let suggestionResponse = try JSONDecoder().decode(SuggestionResponse.self, from: utf8Data)
                        DispatchQueue.main.async {
                            self.suggestions = suggestionResponse.suggestions
                            print("연관 검색어: \(self.suggestions)")
                        }
                    } catch {
                        print("디코딩 오류: \(error)")
                    }
                } else {
                    print("EUC-KR 문자열을 UTF-8 데이터로 변환 불가")
                }
            } else {
                print("데이터를 EUC-KR 문자열로 변환 불가")
            }
        }.resume()
    }


    
}


struct PlaylistItemsResponse: Decodable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let snippet: PlaylistItemSnippet
}

struct PlaylistItemSnippet: Decodable {
    let title: String
    let channelTitle: String
    let thumbnails: PlaylistItemThumbnails
    let resourceId: ResourceID
}

struct PlaylistItemThumbnails: Decodable {
    let medium: Thumbnail
}

struct Thumbnail: Decodable {
    let url: String
}

struct ResourceID: Decodable {
    let videoId: String
}


extension Video {
    init(id: String, title: String, thumbnail: URL, channelTitle: String) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.channelTitle = channelTitle
    }
}


extension String {
    /// HTML 엔티티(예: &#39;, &amp;, &quot; 등)를 디코딩해서 일반 문자열로 반환
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data,
                                                          options: options,
                                                          documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}
