//
//  UIWindow+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static var statusBarFrame: CGRect {
        if #available(iOS 13.0, *) {
            return key?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
    
    static var statusBarHeight: CGFloat {
        return statusBarFrame.size.height
    }
    
    static var navigationBar: CGFloat {
        return UINavigationBar.appearance().frame.size.height
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        return key?.safeAreaInsets ?? UIEdgeInsets.zero
    }
}


extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}


extension UIDevice {
    static var isIphoneX: Bool  {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return true
        }
        if #available(iOS 11.0, *) {
            let bottom = UIWindow.safeAreaInsets.bottom
            if bottom > 0.0 {
                return true
            }
        }
        return false
    }
}
