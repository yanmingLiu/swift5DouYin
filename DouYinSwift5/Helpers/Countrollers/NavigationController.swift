//
//  NavigationController.swift
//  DouYinSwift5
//
//  Created by ym L on 2020/7/23.
//  Copyright © 2020 ym L. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true

        //1.获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        //2.获取手势添加到的View中
        guard  let gesView = systemGes.view else { return }
        //3.取出target
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        //4.取出action
        let action = Selector(("handleNavigationTransition:"))
        //5. 创建自己的pan手势
        let pan = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(pan)
        pan.addTarget(target, action: action)
        pan.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        if (self.value(forKey: "_isTransitioning") as? Bool ?? false) {
            return false
        }
        let translation = gestureRecognizer.location(in: gestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        return true
    }
}

// MARK: - 解决全屏滑动时的手势冲突

extension UIScrollView: UIGestureRecognizerDelegate {
    
    // 当UIScrollView在水平方向滑动到第一个时，默认是不能全屏滑动返回的，通过下面的方法可实现其滑动返回。
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return true
        }
        return false
    }
    
    func panBack(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let point = self.panGestureRecognizer.translation(in: self)
            let state = gestureRecognizer.state
            
            // 设置手势滑动的位置距屏幕左边的区域
            let locationDistance = UIScreen.main.bounds.size.width
            
            if state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.possible {
                let location = gestureRecognizer.location(in: self)
                if point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
}
