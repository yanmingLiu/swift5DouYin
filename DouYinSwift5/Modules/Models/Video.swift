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
            self.playAddr <-- "play_addr"
        
        mapper <<<
            self.dynamicCover <-- "dynamic_cover"
        
        mapper <<<
            self.originCover <-- "origin_cover"
        
        mapper <<<
            self.downloadAddr <-- "download_addr"
        
        mapper <<<
            self.hasWatermark <-- "has_watermark"
        
        mapper <<<
            self.playAddrLowbr <-- "play_addr_lowbr"
    }

}
