//
//  SongModel.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 10/5/24.
//

import Foundation
import AVFAudio


struct SongModel :Equatable {
    let audioFileName: String
    let title: String
    let artist: String
    let imageName: String
    var duration : TimeInterval?
    
    init(audioFileName: String,title: String, artist: String, imageName: String ) {
        self.title = title
        self.artist = artist
        self.imageName = imageName
        self.audioFileName = audioFileName
        self.duration = SongModel.calculateDuration(fileName: audioFileName)
    }
    
    static func calculateDuration(fileName: String) -> TimeInterval? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                return player.duration
            } catch {
                print("오디오 파일 재생시간 계산 중 오류 발생")
            }
        }
        return nil
    }
}
