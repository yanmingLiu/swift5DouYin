//
//  Music.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/27.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Music: HandyJSON {
    var id: Int?
    var idStr: String?
    var title: String?
    var author: String?
    var album: String?
    var coverHd: Resource?
    var coverLarge: Resource?
    var coverMedium: Resource?
    var coverThumb: Resource?
    var playUrl: Resource?
    var ownerId: String?
    var ownerNickname: String?
    var isOriginal: Bool?
    var userCount: Int = 0
    var duration: Int = 0

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            idStr <-- "id_str"

        mapper <<<
            coverHd <-- "cover_hd"

        mapper <<<
            coverLarge <-- "cover_large"

        mapper <<<
            coverMedium <-- "cover_medium"

        mapper <<<
            coverThumb <-- "cover_thumb"

        mapper <<<
            playUrl <-- "play_url"

        mapper <<<
            ownerId <-- "owner_id"

        mapper <<<
            ownerNickname <-- "owner_nickname"

        mapper <<<
            isOriginal <-- "is_original"

        mapper <<<
            userCount <-- "user_count"
    }
}
