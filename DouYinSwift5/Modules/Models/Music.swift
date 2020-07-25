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
    var userCount: Int?
    var duration: Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.idStr <-- "id_str"
        
        mapper <<<
            self.coverHd <-- "cover_hd"
        
        mapper <<<
            self.coverLarge <-- "cover_large"
        
        mapper <<<
            self.coverMedium <-- "cover_medium"
        
        mapper <<<
            self.coverThumb <-- "cover_thumb"
        
        mapper <<<
            self.playUrl <-- "play_url"
        
        mapper <<<
            self.ownerId <-- "owner_id"
        
        mapper <<<
            self.ownerNickname <-- "owner_nickname"
        
        mapper <<<
            self.isOriginal <-- "is_original"
        
        mapper <<<
            self.userCount <-- "user_count"
    }
}
