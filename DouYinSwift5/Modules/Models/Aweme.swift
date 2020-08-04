//
//  aweme.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/27.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Aweme: HandyJSON {
    var awemeId: String?
    var desc:String?
    var createTime:Date?
    var author: Author?
    var music: Music?
    var video: Video?
    var statistics: Statistics?
    var authorUserId: Int?
    var rate: Int?
    var isTop: Int?
    var labelTop: Resource?
    var isAds: Bool?
    var duration: Int?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &awemeId, name: "aweme_id")
        
        mapper <<<
            self.createTime <-- "create_time"
        
        mapper <<<
            self.authorUserId <-- "author_user_id"
        
        mapper <<<
            self.isTop <-- "is_top"
        
        mapper <<<
            self.isAds <-- "is_ads"
        
        mapper <<<
            self.labelTop <-- "label_top"
    }
}
