//
//  PlayerView.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit
import AVFoundation

private let STATUS_KEYPATH = "status"
private var PlayerItemStatusContent: Void?

protocol PlayerViewDelegate: AnyObject {
    
    /// AVPlayerItem状态变化
    /// - Parameter status: AVPlayerItem.Status
    func onItemStatusChange(status: AVPlayerItem.Status)
    
    /// 当前播放时间变化
    /// - Parameters:
    ///   - current: 当前时长
    ///   - duration: 总时长
    func onItemCurrentTimeChange(current: Float64, duration: Float64)
    
    /// 播放状态变化
    /// - Parameter status: 播放状态
    func onPlayerStatusChange(status: PlayerStatus);
}


class PlayerView: UIView {
    
    // MARK: - 属性
    var viewModel: VideoCellViewModel?
    
    weak var delegate: PlayerViewDelegate?
    
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    
    private var timeObserverToken: Any?
    private var playToEndObserverToken: NSObjectProtocol?
    var shouldAutorepeat: Bool = true
    
    var videoGravity: AVLayerVideoGravity {
        set {
            playerLayer.videoGravity = newValue
        }
        get {
            return playerLayer.videoGravity
        }
    }
    
    var assetUrl: URL? {
        didSet {
            prepareToPlay()
        }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // MARK: - life cycle
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(assetUrl: URL) {
        self.assetUrl = assetUrl
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        prepareToPlay()
    }
    
    deinit {
        PlayerManager.shared.pause(player: player)
        PlayerManager.shared.remove(owner: self.viewController() ?? self)
        if let playToEndObserverToken = playToEndObserverToken {
            NotificationCenter.default.removeObserver(playToEndObserverToken, name: .AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playToEndObserverToken = nil
        }
    }
    
    // MARK: - kvo
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            guard let playerItem = self.playerItem, context == &PlayerItemStatusContent else { return }
            playerItem.removeObserver(self, forKeyPath: STATUS_KEYPATH)
            self.addPlayerTimeObserver()
            self.addPlayerItemEndObserver()
            
            self.delegate?.onItemStatusChange(status: playerItem.status)
        }
    }
    
    // MARK: - public
    
    /// 配置播放数据
    public func prepareToPlay() {
        guard let assetUrl = assetUrl else { return }
        //        let asset = AVAsset(url: assetUrl)
        playerItem = AVPlayerItem(url: assetUrl)
        if let player = player {
            PlayerManager.shared.remove(owner: self.viewController() ?? self, player: player)
        }
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerItem.addObserver(self, forKeyPath: STATUS_KEYPATH, options: .new, context: &PlayerItemStatusContent)
        addTapControlGesture()
        play()
    }
    
    public func play() {
        PlayerManager.shared.play(owner: self.viewController() ?? self, player: player)
    }
    
    public func pause() {
        PlayerManager.shared.pasueAll()
    }
    
    
    // MARK: - private
    
    private func addPlayerTimeObserver() {
        let interval = CMTimeMakeWithSeconds(0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (time) in
            let currentTime = CMTimeGetSeconds(time)
            guard let itemDuration = self?.playerItem.duration else { return }
            let duration = CMTimeGetSeconds(itemDuration)
            self?.delegate?.onItemCurrentTimeChange(current: currentTime, duration: duration)
        }
    }
    
    private func addPlayerItemEndObserver() {
        if let playToEndObserverToken = playToEndObserverToken {
            NotificationCenter.default.removeObserver(playToEndObserverToken)
        }
        playToEndObserverToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playerItem,queue: OperationQueue.main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero, completionHandler: {
                if $0, self?.shouldAutorepeat ?? false {
                    self?.player.play()
                }
            }) }
    }
    
    private func addTapControlGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent(gesture:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapGestureEvent(gesture: UITapGestureRecognizer) {
        //当前暂停状态
        if player.rate == 0 {
            play()
            viewModel?.status = .playing
        } else if (player?.rate ?? 0) > 0 {
            pause()
            viewModel?.status = .pause
        }
        self.delegate?.onPlayerStatusChange(status: viewModel?.status ?? PlayerStatus.none)
    }
}
