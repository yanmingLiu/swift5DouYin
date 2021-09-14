//
//  Video.swift
//  DouyinSwift
//
//  Created by 赵福成 on 2019/5/27.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import Foundation
import HandyJSON

struct Video: HandyJSON {
    var playAddr: Resource?
    var cover: Resource?
    var height: Int?
    var width: Int?
    var dynamicCover: Resource?
    var originCover: Resource?
    var ratio: String?
    var downloadAddr: Resource?
    var hasWatermark: Bool?
    var playAddrLowbr: Resource?
    var duration: Int?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            playAddr <-- "play_addr"

        mapper <<<
            dynamicCover <-- "dynamic_cover"

        mapper <<<
            originCover <-- "origin_cover"

        mapper <<<
            downloadAddr <-- "download_addr"

        mapper <<<
            hasWatermark <-- "has_watermark"

        mapper <<<
            playAddrLowbr <-- "play_addr_lowbr"
    }
}
