//
//  VideoCellViewModel.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation
import Kingfisher

enum PlayerStatus {
    case none
    case pause
    case playing
}

class VideoCellViewModel {
    var status: PlayerStatus = .none
    var isLikedStatus: Bool = false
    var isFollowStatus: Bool = false

    let aweme: Aweme

    init(aweme: Aweme) {
        self.aweme = aweme
    }

    public var playUrl: URL? {
        guard let urlStr = aweme.video?.playAddr?.urlList?.first else { return nil }
        let url = URL(string: urlStr)
        return url
    }

    public var diggCount: String {
        return aweme.statistics?.diggCount.readability ?? "0"
    }

    public var commentCount: String {
        return aweme.statistics?.commentCount.readability ?? "0"
    }

    public var shareCount: String {
        return aweme.statistics?.shareCount.readability ?? "0"
    }

    public var musicThumb: URL? {
        guard let str = aweme.music?.coverThumb?.urlList?.first else { return nil }
        return URL(string: str) ?? nil
    }

    public var avatarThumb: URL? {
        guard let str = aweme.author?.avatarThumb?.urlList?.first else { return nil }
        return URL(string: str) ?? nil
    }

    public var musicName: String {
        guard let title = aweme.music?.title else { return "" }
        return title.contains("原声") ? title : "\(title) - \(aweme.music?.author ?? "")"
    }

    public var videoDesc: String? {
        return aweme.desc
    }

    public var authorName: String {
        guard let nickName = aweme.author?.nickName else {
            return ""
        }
        return nickName
    }

    public var dynamicCover: URL? {
        guard let urlStr = aweme.video?.dynamicCover?.urlList?.first else { return nil }
        print(urlStr)
        return URL(string: urlStr) ?? nil
    }

    public var isTop: Bool {
        return aweme.isTop == 1 ? true : false
    }

    public var topIcon: URL? {
        guard let urlStr = aweme.labelTop?.urlList?.first else { return nil }
        return URL(string: urlStr) ?? nil
    }
}

extension Int {
    var readability: String {
        if self < 10000 {
            return "\(self)"
        } else {
            return String(format: "%.1fw", Float(self) / 10000)
        }
    }
}
