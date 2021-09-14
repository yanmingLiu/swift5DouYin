//
//  VideoFeedCell.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import AVFoundation
import Kingfisher
import Lottie
import MediaPlayer
import UIKit

class VideoFeedCell: UITableViewCell {
    private var playImage: UIImageView!
    private var playerView: PlayerView!
    private var musicDiscBtn: VideoFeedCellMusicBtn!
    private var shareBtn: VideoFeedCellButton!
    private var commentBtn: VideoFeedCellButton!
    private var likeBtn: AnimationView!
    private var likeCount: UILabel!
    private var avatar: UIImageView!
    private var followBtn: AnimationView!
    private var musicIcon: UIImageView!
    private var musicName: VideoFeedCellMusicAlbumNameBtn!
    private var videoDesc: ZLabel!
    private var authorName: ZLabel!
    private var progressView: UIProgressView!

    private var viewModel: VideoCellViewModel?
    private(set) var isReadyToPlay: Bool = false

    public var startPlayOnReady: (() -> Void)?

    public var onDidSelectCommentButton: ((_ cell: VideoFeedCell, _ viewModel: VideoCellViewModel) -> Void)?

    private let avatarImage = R.image.img_find_default()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        progressView.progress = 0
        addFollowBtn()
        musicDiscBtn.resetAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    public func bind(viewModel: VideoCellViewModel) {
        self.viewModel = viewModel
        playerView.viewModel = viewModel
        playerView.assetUrl = viewModel.playUrl
        playImageAnimation(status: viewModel.status)
        viewModel.status = .none
        likeCount.text = viewModel.diggCount
        commentBtn.label.text = viewModel.commentCount
        shareBtn.label.text = viewModel.shareCount
        musicDiscBtn.cover.kf.setImage(with: viewModel.musicThumb)
        avatar.kf.setImage(with: viewModel.avatarThumb)
        musicName.text = viewModel.musicName
        videoDesc.text = viewModel.videoDesc
        authorName.text = viewModel.authorName

        if viewModel.isFollowStatus {
            followBtn.animation = Animation.named("", subdirectory: "")
        } else {
            followBtn.animation = Animation.named("home_follow_add", subdirectory: "LottieResources")
        }

        if viewModel.isLikedStatus {
            likeBtn.animation = Animation.named("icon_home_dislike_new", subdirectory: "LottieResources")
        } else {
            likeBtn.animation = Animation.named("icon_home_like_new", subdirectory: "LottieResources")
        }
    }

    public func play() {
        if isReadyToPlay {
            playerView.play()
        }
    }

    // 播放/暂停 按钮动画
    private func playImageAnimation(status: PlayerStatus) {
        switch status {
        case .pause:
            isReadyToPlay = false
            playImage.isHidden = false
            playImage.alpha = 0
            playImage.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            UIView.animate(withDuration: 0.15, animations: {
                self.playImage.alpha = 1
                self.playImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            musicDiscBtn.pauseAnimation()
            musicName.pauseAnimation()
        case .playing:
            isReadyToPlay = true
            UIView.animate(withDuration: 0.15, animations: {
                self.playImage.alpha = 0
            }, completion: { _ in
                self.playImage.isHidden = false
            })
            musicDiscBtn.resumeAnimtion()
            musicName.resumeAnimation()
        case .none:
            isReadyToPlay = false
            playImage.isHidden = true
        }
    }
}

// MARK: - UI

extension VideoFeedCell {
    func setUpUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        addBackgroundImage()
        addPlayerView()
        addPlayImage()
        addMusicDisc()
        addShareBtn()
        addCommentBtn()
        addLikeBtn()
        addAvatar()
        addFollowBtn()
        addMusicName()
        addVideoDesc()
        addAuthorName()
        addVolumeProgressView()
    }

    /// 背景图片
    func addBackgroundImage() {
        let backgroundImage = UIImageView()
        backgroundImage.image = R.image.img_video_loading_max375x685()
        backgroundImage.contentMode = .scaleAspectFill
        contentView.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    /// 暂停图片
    func addPlayImage() {
        playImage = UIImageView()
        playImage.image = R.image.icon_play_pause52x62()
        contentView.addSubview(playImage)
        playImage.translatesAutoresizingMaskIntoConstraints = false
        playImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        playImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }

    /// 播放view
    func addPlayerView() {
        playerView = PlayerView()
        playerView.delegate = self
        contentView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        playerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }

    /// 音乐按钮
    func addMusicDisc() {
        musicDiscBtn = VideoFeedCellMusicBtn()
        contentView.addSubview(musicDiscBtn)
        musicDiscBtn.translatesAutoresizingMaskIntoConstraints = false
        musicDiscBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        musicDiscBtn.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }

    /// 分享按钮
    func addShareBtn() {
        shareBtn = VideoFeedCellButton()
        shareBtn.imageView.image = R.image.icon_home_share40x40()
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        contentView.addSubview(shareBtn)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.centerXAnchor.constraint(equalTo: musicDiscBtn.centerXAnchor).isActive = true
        shareBtn.bottomAnchor.constraint(equalTo: musicDiscBtn.topAnchor, constant: -40).isActive = true
    }

    /// 评论按钮
    func addCommentBtn() {
        commentBtn = VideoFeedCellButton()
        commentBtn.imageView.image = R.image.icon_home_share40x40()
        commentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        contentView.addSubview(commentBtn)
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.centerXAnchor.constraint(equalTo: musicDiscBtn.centerXAnchor).isActive = true
        commentBtn.bottomAnchor.constraint(equalTo: shareBtn.topAnchor, constant: -10).isActive = true
    }

    /// 喜欢按钮
    func addLikeBtn() {
        likeCount = UILabel()
        likeCount.text = "0"
        likeCount.font = .systemFont(ofSize: 12)
        likeCount.textColor = UIColor.white

        likeBtn = AnimationView()
        likeBtn.clipsToBounds = true
        let imageProvider = BundleImageProvider(bundle: Bundle.main, searchPath: "LottieResources")
        likeBtn.imageProvider = imageProvider
        contentView.addSubview(likeBtn)
        contentView.addSubview(likeCount)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.centerXAnchor.constraint(equalTo: musicDiscBtn.centerXAnchor).isActive = true
        likeBtn.bottomAnchor.constraint(equalTo: commentBtn.topAnchor, constant: -25).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 55).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        likeCount.topAnchor.constraint(equalTo: likeBtn.bottomAnchor).isActive = true
        likeCount.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        likeBtn.addGestureRecognizer(tap)
    }

    /// 头像按钮
    func addAvatar() {
        avatar = UIImageView()
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        avatar.layer.cornerRadius = 25
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.borderWidth = 1
        contentView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.bottomAnchor.constraint(equalTo: likeBtn.topAnchor, constant: -25).isActive = true
        avatar.centerXAnchor.constraint(equalTo: musicDiscBtn.centerXAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarAction))
        avatar.addGestureRecognizer(tap)
    }

    /// 关注按钮
    func addFollowBtn() {
        if followBtn != nil, followBtn.superview != nil { return }
        followBtn = AnimationView()
        followBtn.animation = Animation.named("home_follow_add", subdirectory: "LottieResources")
        contentView.addSubview(followBtn)
        followBtn.translatesAutoresizingMaskIntoConstraints = false
        followBtn.centerXAnchor.constraint(equalTo: avatar.centerXAnchor).isActive = true
        followBtn.centerYAnchor.constraint(equalTo: avatar.bottomAnchor).isActive = true
        followBtn.widthAnchor.constraint(equalToConstant: 34).isActive = true
        followBtn.heightAnchor.constraint(equalToConstant: 34).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(followAction))
        followBtn.addGestureRecognizer(tap)
    }

    /// 音乐icon 名字
    func addMusicName() {
        musicIcon = UIImageView()
        musicIcon.image = R.image.icon_home_musicnote3()
        contentView.addSubview(musicIcon)
        musicName = VideoFeedCellMusicAlbumNameBtn()
        contentView.addSubview(musicName)
        musicIcon.translatesAutoresizingMaskIntoConstraints = false
        musicName.translatesAutoresizingMaskIntoConstraints = false
        musicIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        musicIcon.bottomAnchor.constraint(equalTo: musicDiscBtn.bottomAnchor).isActive = true
        musicIcon.setContentHuggingPriority(.required, for: .vertical)
        musicName.leftAnchor.constraint(equalTo: musicIcon.rightAnchor, constant: 5).isActive = true
        musicName.centerYAnchor.constraint(equalTo: musicIcon.centerYAnchor).isActive = true
        musicName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        musicName.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    /// 视频简介
    func addVideoDesc() {
        videoDesc = ZLabel(frame: CGRect.zero)
        videoDesc.delegate = self
        videoDesc.font = .systemFont(ofSize: 14)
        videoDesc.textColor = UIColor(white: 1, alpha: 0.9)
        videoDesc.numberOfLines = 3
        contentView.addSubview(videoDesc)
        videoDesc.translatesAutoresizingMaskIntoConstraints = false
        videoDesc.leftAnchor.constraint(equalTo: musicIcon.leftAnchor).isActive = true
        videoDesc.bottomAnchor.constraint(equalTo: musicIcon.topAnchor, constant: -8).isActive = true
        videoDesc.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.67).isActive = true
    }

    /// 作者
    func addAuthorName() {
        authorName = ZLabel(frame: CGRect.zero)
        authorName.delegate = self
        authorName.isAllSelected = true
        authorName.font = .boldSystemFont(ofSize: 16)
        authorName.linkTextFont = .boldSystemFont(ofSize: 16)
        authorName.textColor = UIColor.white
        contentView.addSubview(authorName)
        authorName.translatesAutoresizingMaskIntoConstraints = false
        authorName.leftAnchor.constraint(equalTo: musicIcon.leftAnchor).isActive = true
        authorName.bottomAnchor.constraint(equalTo: videoDesc.topAnchor, constant: -8).isActive = true
        authorName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }

    /// 进度条
    func addVolumeProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .white
        progressView.alpha = 1
        contentView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    @objc func likeAction() {
        likeBtn.play(completion: { [weak self] _ in
            self!.viewModel!.isLikedStatus = !self!.viewModel!.isLikedStatus

            if self!.viewModel!.isLikedStatus {
                self!.likeBtn.animation = Animation.named("icon_home_dislike_new", subdirectory: "LottieResources")
            } else {
                self!.likeBtn.animation = Animation.named("icon_home_like_new", subdirectory: "LottieResources")
            }
        })
    }

    @objc func shareAction() {}

    @objc func followAction() {
        followBtn.play(completion: { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self?.followBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                self?.followBtn.removeFromSuperview()
                self!.viewModel!.isFollowStatus = !self!.viewModel!.isFollowStatus
            })
        })
    }

    @objc func commentAction() {
        onDidSelectCommentButton?(self, viewModel!)
    }

    @objc func avatarAction() {
        let vc = UserPageViewController()
        viewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ZLabelDelegate

extension VideoFeedCell: ZLabelDelegate {
    func labelDidSelectedLinkText(label _: ZLabel, text: String) {
        let vc = UIAlertController(title: "点击了文本", message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        vc.addAction(cancel)
        viewController()?.present(vc, animated: true, completion: nil)
    }
}

// MARK: - PlayerViewDelegate

extension VideoFeedCell: PlayerViewDelegate {
    func onItemCurrentTimeChange(current: Float64, duration: Float64) {
        //        print(" current = \(current), duration = \(duration)")
        let progress = Float(current / duration)
        progressView.setProgress(progress, animated: true)
    }

    func onItemStatusChange(status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            isReadyToPlay = true
            startPlayOnReady?()
            musicDiscBtn.setUpAnimation()
            musicName.setUpAnimation()
        default:
            break
        }
    }

    func onPlayerStatusChange(status _: PlayerStatus) {
        playImageAnimation(status: viewModel!.status)
    }
}
