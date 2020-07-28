//
//  MusicCellViewModel.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation


class MusicCellViewModel {
    
    var music: Music!
    
    init(music: Music) {
        self.music = music
    }
    
    public var musicCover: URL? {
        guard let str = music.coverThumb?.urlList?.first else { return nil }
        return URL(string: str) ?? nil
    }
    
    public var musicName: String? {
        return music.title
    }

    public var userCount: String {
      return "\(music.userCount) 个视频使用"
    }
    
    public var duration: String? {
        let duration = music.duration
        let m = duration / 60
        let s = duration - m * 60
        return "\(m > 10 ? "\(m)" : "0\(m)") : \(s > 10 ? "\(s)" : "0\(s)")"
    }

}
