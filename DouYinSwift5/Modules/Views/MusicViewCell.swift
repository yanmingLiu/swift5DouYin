//
//  MusicViewCell.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

class MusicViewCell: UITableViewCell {
    private var playBtn: UIButton!
    private var musicName: UILabel!
    private var countLabel: UILabel!
    private var timeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func bind(viewModel: MusicCellViewModel) {
        playBtn.kf.setBackgroundImage(with: viewModel.musicCover, for: .normal)
        musicName.text = viewModel.musicName
        countLabel.text = viewModel.userCount
        timeLabel.text = viewModel.duration
    }

    private func setUpUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        playBtn = UIButton(type: .custom)
        playBtn.setImage(UIImage(named: "icon_playmusic30x30"), for: .normal)
        contentView.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true

        let icon = UIImageView(image: UIImage(named: "icon_home_original_musicnote16x16"))
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: playBtn.topAnchor, constant: 4).isActive = true
        icon.leftAnchor.constraint(equalTo: playBtn.rightAnchor, constant: 10).isActive = true

        musicName = UILabel()
        musicName.font = .boldSystemFont(ofSize: 16)
        musicName.textColor = UIColor.white
        musicName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(musicName)
        musicName.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        musicName.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 4).isActive = true

        countLabel = UILabel()
        countLabel.text = "0 个视频使用"
        countLabel.font = .systemFont(ofSize: 12)
        countLabel.textColor = UIColor(white: 1, alpha: 0.7)
        contentView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.leftAnchor.constraint(equalTo: icon.leftAnchor).isActive = true
        countLabel.topAnchor.constraint(equalTo: musicName.bottomAnchor, constant: 5).isActive = true

        timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = UIColor(white: 1, alpha: 0.7)
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leftAnchor.constraint(equalTo: icon.leftAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: -4).isActive = true

        let btnStack = UIStackView()
        btnStack.axis = .horizontal
        btnStack.spacing = 20
        contentView.addSubview(btnStack)
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        btnStack.topAnchor.constraint(equalTo: playBtn.topAnchor, constant: 5).isActive = true

        let collectionBtn = UIButton(type: .system)
        collectionBtn.setImage(UIImage(named: "icon_white_nocollection24x24")?.withRenderingMode(.alwaysOriginal), for: .normal)

        let detailBtn = UIButton(type: .system)
        detailBtn.setImage(UIImage(named: "icon_ost_detail24x24")?.withRenderingMode(.alwaysOriginal), for: .normal)

        btnStack.addArrangedSubview(collectionBtn)
        btnStack.addArrangedSubview(detailBtn)
    }
}
