//
//  VideoListViewModel.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/24.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation
import HandyJSON

class VideoListViewModel {
    
    var list = [VideoCellViewModel]()
    
    public func loadData(page: Int = 1, success: @escaping ()->Void) {
        let path = "feed\(page).json"
        guard let filePath = Bundle.main.path(forResource: path, ofType: nil) else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let dataJson = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataJson, options: .prettyPrinted)
            let json = String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
            print(json)
            let arr = [Aweme].deserialize(from: json, designatedPath: "aweme_list") as! [Aweme]
            arr.forEach { (a) in
                list.append(VideoCellViewModel(aweme: a))
            }
            success()
        } catch  {
            debugPrint("获取tabbar.json异常")
        }
    }
}
