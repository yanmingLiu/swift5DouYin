//
//  String+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
    ///
    /// - Parameter font: 字体
    /// - Returns: 文字大小
    func singleLineSize(font: UIFont) -> CGSize {
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        var leading = font.lineHeight - font.ascender + font.descender
        var paragraphSettings = [
            CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &leading),
        ]
        let paragraphStyle = CTParagraphStyleCreate(&paragraphSettings, 1)
        let ocString = self as NSString
        let textRange = CFRange(location: 0, length: ocString.length)
        let string = CFAttributedStringCreateMutable(kCFAllocatorDefault, ocString.length)
        CFAttributedStringReplaceString(string, CFRangeMake(0, 0), ocString)
        CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont)
        CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle)
        guard let lstring = string else { return CGSize.zero }
        let framesetter = CTFramesetterCreateWithAttributedString(lstring)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), nil)
    }

    /// 指定字体单行高度
    ///
    /// - Parameter font: 字体
    /// - Returns: 高度
    func height(for font: UIFont) -> CGFloat {
        return size(for: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height
    }

    /// 指定字体单行宽度
    ///
    /// - Parameter font: 字体
    /// - Returns: 宽度
    func width(for font: UIFont) -> CGFloat {
        return size(for: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).width
    }

    /// 计算指定字体的尺寸
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - size: 区域大小
    ///   - lineBreakMode: 换行模式
    /// - Returns: 尺寸
    func size(for font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if lineBreakMode != .byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[.paragraphStyle] = paragraphStyle
        }
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attr, context: nil)
        return rect.size
    }

    /// 正则匹配
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    /// - Returns: 是否匹配
    func matches(regex: String, options: NSRegularExpression.Options) -> Bool {
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else { return false }
        return pattern.numberOfMatches(in: self, options: [], range: rangeOfAll) > 0
    }

    /// 枚举所有正则表达式匹配项
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    ///   - closure: 功能闭包
    func enumerate(regex: String, options: NSRegularExpression.Options, closure: (_ match: String, _ matchRange: Range<String.Index>, _ stop: UnsafeMutablePointer<ObjCBool>) -> Void) {
        guard regex.isNotBlank else { return }
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else { return }
        pattern.enumerateMatches(in: self, options: [], range: rangeOfAll) { result, _, stop in
            if let result = result, let range = range(for: result.range) {
                closure(String(self[range]), range, stop)
            }
        }
    }

    /// 正则替换
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    ///   - with: 待替换字符串
    /// - Returns: 新的字符串
    func replace(regex: String, options: NSRegularExpression.Options, with: String) -> String? {
        guard regex.isNotBlank else { return nil }
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else { return nil }
        return pattern.stringByReplacingMatches(in: self, options: [], range: rangeOfAll, withTemplate: with)
    }

    func append(scale: CGFloat) -> String {
        if fabsf(Float(scale - 1)) <= .ulpOfOne || !isNotBlank || hasSuffix("/") { return self }
        return appendingFormat("@%dx", Int(scale))
    }
}

public extension String {
    /// 返回组成字符串的字符数组
    var charactersArray: [Character] {
        return Array(self)
    }

    /// 去掉字符串首尾的空格换行，中间的空格和换行忽略
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 是否不为空
    ///
    /// "", "  ", "\n", "  \n   "都视为空
    /// 不为空返回true， 为空返回false
    var isNotBlank: Bool {
        return !trimmed.isEmpty
    }

    /// 字符串的全部范围
    var rangeOfAll: NSRange {
        return NSRange(location: 0, length: count)
    }

    /// NSRange转换为当前字符串的Range
    ///
    /// - Parameter range: NSRange对象
    /// - Returns: 当前字符串的范围
    func range(for range: NSRange) -> Range<String.Index>? {
        return Range(range, in: self)
    }
}
