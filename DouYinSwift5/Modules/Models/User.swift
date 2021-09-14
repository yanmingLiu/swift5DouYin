//
//  User.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/27.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Author: HandyJSON {
    var uid: String?
    var nickName: String?
    var signature: String?
    var avatarLarger: Resource?
    var avatarThumb: Resource?
    var avatarMedium: Resource?
    var birthday: String?
    var isVerified: Bool?
    var followStatus: Int?
    var awemeCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    var favoritingCount: Int?
    var totalFavorited: Int?
    var constellation: Int?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            nickName <-- "nickname"

        mapper <<<
            avatarLarger <-- "avatar_larger"

        mapper <<<
            avatarThumb <-- "avatar_thumb"

        mapper <<<
            avatarMedium <-- "avatar_medium"

        mapper <<<
            isVerified <-- "is_verified"

        mapper <<<
            followStatus <-- "follow_status"

        mapper <<<
            awemeCount <-- "aweme_count"

        mapper <<<
            followingCount <-- "following_count"

        mapper <<<
            favoritingCount <-- "favoriting_count"

        mapper <<<
            totalFavorited <-- "total_favorited"
    }
}
