//
//  MusicListViewModel.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation

class MusicListViewModel {
    var list = [MusicCellViewModel]()

    public func loadData(success: @escaping () -> Void) {
        let path = "UserMusicList.json"
        guard let filePath = Bundle.main.path(forResource: path, ofType: nil) else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let dataJson = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataJson, options: .prettyPrinted)
            let json = String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
            print(json)
            let arr = [Music].deserialize(from: json, designatedPath: "music") as! [Music]
            arr.forEach { a in
                list.append(MusicCellViewModel(music: a))
            }
            success()
        } catch {
            debugPrint("获取.json异常")
        }
    }
}
