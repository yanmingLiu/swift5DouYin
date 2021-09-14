//
//  VideoViewCell.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import Kingfisher
import UIKit

class VideoViewCell: UICollectionViewCell {
    private var coverImage: UIImageView!
    private var countLabel: UILabel!
    private var topIcon: UIImageView!

    override init(frame _: CGRect) {
        super.init(frame: CGRect.zero)
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func bind(viewModel: VideoCellViewModel) {
        coverImage.kf.setImage(with: URL(string: "https://pb3.pstatp.com/origin/pgc-image/91f2035964cb473b8429298d0ef90246")!)
        topIcon.isHidden = !viewModel.isTop
        topIcon.kf.setImage(with: viewModel.topIcon)
        countLabel.text = viewModel.diggCount
    }

    func setUpUI() {
        coverImage = UIImageView()
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        contentView.addSubview(coverImage)

        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        coverImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let likeIcon = UIImageView(image: R.image.icon_home_likenum())
        addSubview(likeIcon)
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        likeIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        likeIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        countLabel = UILabel()
        countLabel.font = .boldSystemFont(ofSize: 11)
        countLabel.textColor = UIColor.white
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.leftAnchor.constraint(equalTo: likeIcon.rightAnchor, constant: 5).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor).isActive = true

        topIcon = UIImageView()
        topIcon.isHidden = true
        addSubview(topIcon)
        topIcon.translatesAutoresizingMaskIntoConstraints = false
        topIcon.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        topIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    }
}
