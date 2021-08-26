//
//  CommentListTableView.swift
//  DouYinSwift5
//
//  Created by lym on 2021/8/26.
//  Copyright © 2021 lym. All rights reserved.
//

import UIKit

class CommentListTableView: UITableView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let contentOffset = self.contentOffset
            let velocity = pan.velocity(in: pan.view)
            if contentOffset.y == -contentInset.top {
                print(velocity)
                // 关键点: 当前是最顶点, 不允许往下滑动
                if velocity.y > 0 {
                    // 向下
                    return false
                }
            }
        }
        return true
    }
}
