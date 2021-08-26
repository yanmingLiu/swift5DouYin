//
//  PlayerManager.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerManager {
    static let shared: PlayerManager = PlayerManager()
    private var playerDic: [Int:AVPlayer] = [:]
    private init() { }
    
    class func configAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
        } catch {
            print("Audio session config error \(error)")
        }
    }
    
    public func play<T>(owner:T ,player: AVPlayer) where T: Hashable {
        pause(owner: owner)
        playerDic[owner.hashValue] = player
        player.play()
    }
    
    public func pause(player: AVPlayer) {
        player.pause()
    }
    
    public func pause<T>(owner: T) where T: Hashable {
        guard let player  = playerDic[owner.hashValue] else { return }
        player.pause()
    }
    
    public func pauseAll() {
        playerDic.values.forEach { $0.pause() }
    }
    
    public func remove<T>(owner: T, player: AVPlayer) where T: Hashable {
        player.pause()
        guard let p = playerDic[owner.hashValue], p == player else {
            return
        }
        playerDic[owner.hashValue] = nil
    }
    
    public func remove<T>(owner: T) where T: Hashable {
        playerDic.removeValue(forKey: owner.hashValue)
    }
    
    public func removeAll() {
        playerDic.removeAll()
    }
}
