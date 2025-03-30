//
//  VideoObject.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/12/25.
//

import Foundation
import RealmSwift

class VideoObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String = ""
    // URL은 직접 저장할 수 없으므로 String 형태로 저장
    @Persisted var thumbnailURL: String = ""
    @Persisted var channelTitle : String = ""
    
    convenience init(video: Video) {
        self.init()
        self.id = video.id
        self.title = video.title
        self.thumbnailURL = video.thumbnail.absoluteString
        self.channelTitle = video.channelTitle
    }
}

