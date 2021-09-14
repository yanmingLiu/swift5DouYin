//
//  Statistics.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/28.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Statistics: HandyJSON {
    var awemeId: String?
    var commentCount: Int!
    var diggCount: Int!
    var downloadCount: Int!
    var playCount: Int!
    var shareCount: Int!
    var forwardCount: Int!

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            awemeId <-- "aweme_id"
        mapper <<<
            commentCount <-- "comment_count"
        mapper <<<
            diggCount <-- "digg_count"
        mapper <<<
            downloadCount <-- "download_count"
        mapper <<<
            playCount <-- "play_count"
        mapper <<<
            shareCount <-- "share_count"
        mapper <<<
            forwardCount <-- "forward_count"
    }
}
