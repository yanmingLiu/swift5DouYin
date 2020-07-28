//
//  VideoViewCell.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//


import UIKit
import Kingfisher

class VideoViewCell: UICollectionViewCell {
    
    private var coverImage: UIImageView!
    private var countLable: UILabel!
    private var topIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(viewModel: VideoCellViewModel) {        
        coverImage.kf.setImage(with: viewModel.dynamicCover)
        topIcon.isHidden = viewModel.isTop
        topIcon.kf.setImage(with: viewModel.topIcon)
        countLable.text = viewModel.diggCount
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
        
        let likeIcon = UIImageView(image: UIImage(named: "icon_home_likenum"))
        addSubview(likeIcon)
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        likeIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        likeIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        countLable = UILabel()
        countLable.font = .boldSystemFont(ofSize: 11)
        countLable.textColor = UIColor.white
        addSubview(countLable)
        countLable.translatesAutoresizingMaskIntoConstraints = false
        countLable.leftAnchor.constraint(equalTo: likeIcon.rightAnchor, constant: 5).isActive = true
        countLable.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor).isActive = true
        
        topIcon = UIImageView()
        topIcon.isHidden = true
        addSubview(topIcon)
        topIcon.translatesAutoresizingMaskIntoConstraints = false
        topIcon.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        topIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    }

}
