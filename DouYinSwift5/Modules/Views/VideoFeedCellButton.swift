//
//  VideoFeedCellBtn.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/24.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

class VideoFeedCellButton: UIControl {
    public let imageView: UIImageView
    public let label: UILabel

    required init() {
        imageView = UIImageView()

        label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 12)
        super.init(frame: CGRect.zero)

        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        label.textColor = UIColor.white
        addSubview(label)
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        imageViewScaleAnimation(isPressed: true)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        imageViewScaleAnimation(isPressed: false)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        imageViewScaleAnimation(isPressed: false)
    }

    private func imageViewScaleAnimation(isPressed: Bool) {
        let scale = isPressed
            ? CGAffineTransform(scaleX: 1.2, y: 1.2)
            : CGAffineTransform(scaleX: 1.0, y: 1.0)

        UIView.animate(withDuration: 0.1) {
            self.imageView.transform = scale
        }
    }
}
