//
//  AppDelegate.swift
//  DouYinSwift5
//
//  Created by ym L on 2020/7/23.
//  Copyright © 2020 ym L. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarController()
        PlayerManager.configAudioSession()
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

