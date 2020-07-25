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
            self.nickName <-- "nickname"

        mapper <<<
            self.avatarLarger <-- "avatar_larger"

        mapper <<<
            self.avatarThumb <-- "avatar_thumb"

        mapper <<<
            self.avatarMedium <-- "avatar_medium"

        mapper <<<
            self.isVerified <-- "is_verified"

        mapper <<<
            self.followStatus <-- "follow_status"

        mapper <<<
            self.awemeCount <-- "aweme_count"

        mapper <<<
            self.followingCount <-- "following_count"

        mapper <<<
            self.favoritingCount <-- "favoriting_count"

        mapper <<<
            self.totalFavorited <-- "total_favorited"
    }
}
