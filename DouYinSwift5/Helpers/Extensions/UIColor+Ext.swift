//
//  UIColor+.swift
//  Demo1
//
//  Created by lym on 2019/5/22.
//  Copyright © 2019 lym. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// 随机颜色
    class var random: UIColor {
        get {
            return UIColor(red: CGFloat(arc4random()%256) / 255.0, green: CGFloat(arc4random()%256) / 255.0, blue: CGFloat(arc4random()%256) / 255.0, alpha: 0.5)
        }
    }

    /// 根据16进制颜色值返回颜色
    /// - Parameters:
    ///   - hexString: 颜色值字符串: 前缀 ‘#’ 和 ‘0x’ 不是必须的
    ///   - alpha: 透明度，默认为1
    /// - Returns: UIColor
    static func hexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        var str = ""
        if hexString.lowercased().hasPrefix("0x") {
            str = hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.lowercased().hasPrefix("#") {
            str = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            str = hexString
        }
        
        let length = str.count
        // 如果不是 RGB RGBA RRGGBB RRGGBBAA 结构
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return .clear
        }
        
        // 将 RGB RGBA 转换为 RRGGBB RRGGBBAA 结构
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }
        
        guard let hexValue = Int(str, radix: 16) else { return .clear }
        
        var red = 0
        var green = 0
        var blue = 0
        
        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xff
            green = (hexValue >> 8) & 0xff
            blue = hexValue & 0xff
        } else {
            red = (hexValue >> 20) & 0xff
            green = (hexValue >> 16) & 0xff
            blue = (hexValue >> 8) & 0xff
        }
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
}

