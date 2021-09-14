//
//  NavigationController.swift
//  DouYinSwift5
//
//  Created by ym L on 2020/7/23.
//  Copyright © 2020 ym L. All rights reserved.
//

import UIKit

// weak与弱引用计数有关，只能修饰对象，不能修饰协议限制的any, 这里可以用 NSObjectProtocol、class、@objc protocol
protocol NavigationControllerDelegate: NSObjectProtocol {
    func popGestureRecognizerShouldBegin() -> Bool
}

extension NavigationControllerDelegate {
    func popGestureRecognizerShouldBegin() -> Bool {
        return true
    }
}

class NavigationController: UINavigationController {
    weak var popDelegate: NavigationControllerDelegate?

    private var pan: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true

        addFullScreenPan()
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

    private func addFullScreenPan() {
        // 1.获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        // 2.获取手势添加到的View中
        guard let gesView = systemGes.view else { return }
        // 3.取出target
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        // 4.取出action
        let action = Selector(("handleNavigationTransition:"))
        // 5. 创建自己的pan手势
        pan = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(pan)
        pan.addTarget(target, action: action)
        pan.delegate = self
    }

    // 保留系统手势
    func disabledFullScreenPan() {
        pan.isEnabled = false
        interactivePopGestureRecognizer?.delegate = self
    }

    // 关闭全屏 和 系统
    func disabledPopGesture() {
        pan.isEnabled = false
    }

    // 开启全屏
    func enabledFullScreenPan() {
        pan.isEnabled = true
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        if value(forKey: "_isTransitioning") as? Bool ?? false {
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
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return false
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognizer: gestureRecognizer) {
            return true
        }
        return false
    }

    func panBack(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let point = panGestureRecognizer.translation(in: self)
            let state = gestureRecognizer.state

            // 设置手势滑动的位置距屏幕左边的区域
            let locationDistance = UIScreen.main.bounds.size.width

            if state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.possible {
                let location = gestureRecognizer.location(in: self)
                if point.x > 0, location.x < locationDistance, contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
}
