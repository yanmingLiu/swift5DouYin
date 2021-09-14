//
//  Avatar.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/27.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Resource: HandyJSON {
    var uri: String?
    var urlList: [String]?
    var width: Int?
    var height: Int?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            urlList <-- "url_list"
    }
}
