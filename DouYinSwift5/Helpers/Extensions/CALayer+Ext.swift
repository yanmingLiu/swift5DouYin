//
//  CALayer+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

public extension CALayer {
    /// 暂停动画
    func pauseAnimation() {
        // 取出当前时间,转成动画暂停的时间
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        // 设置动画运行速度为0
        speed = 0.0
        // 设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        timeOffset = pausedTime
    }

    /// 恢复动画
    func resumeAnimation() {
        // 获取暂停的时间差
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        // 用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}
