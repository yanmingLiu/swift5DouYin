//
//  PageSegmentView.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

protocol PageSegmentViewDelegate: AnyObject {
    func pageSegment(selectedIndex index: Int)
}

class PageSegmentView: UIView {
    private var labels: [UILabel] = []
    private var indicateView: UIView!
    private var indicateViewCenterX: NSLayoutConstraint!
    private var currentTag: Int = 0

    public weak var delegate: PageSegmentViewDelegate?

    init() {
        super.init(frame: CGRect.zero)
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        indicateView = UIView()
        indicateView.backgroundColor = badgeColor
        addSubview(indicateView)
        indicateView.translatesAutoresizingMaskIntoConstraints = false
        indicateView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicateView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        let titles = ["音乐 174", "动态 98", "喜欢 75"]
        for (index, title) in titles.enumerated() {
            let titleLab = UILabel()
            titleLab.text = title
            titleLab.textAlignment = .center
            titleLab.font = .systemFont(ofSize: 16)
            titleLab.tag = index
            labels.append(titleLab)
            stack.addArrangedSubview(titleLab)

            if index == currentTag {
                titleLab.textColor = UIColor(white: 1, alpha: 1)
                titleLab.font = .boldSystemFont(ofSize: 16)
                indicateViewCenterX = indicateView.centerXAnchor.constraint(equalTo: titleLab.centerXAnchor)
                indicateViewCenterX.isActive = true
                indicateView.widthAnchor.constraint(equalTo: titleLab.widthAnchor).isActive = true
            } else {
                titleLab.textColor = UIColor(white: 1, alpha: 0.6)
                titleLab.font = .systemFont(ofSize: 16)
            }
            titleLab.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tapGes:)))
            titleLab.addGestureRecognizer(tap)
        }
    }

    @objc func tapGestureHandler(tapGes: UITapGestureRecognizer) {
        guard let targetLabel = tapGes.view as? UILabel else { return }

        let currentLabel = labels[currentTag]

        removeConstraint(indicateViewCenterX)
        indicateViewCenterX = indicateView.centerXAnchor.constraint(equalTo: targetLabel.centerXAnchor)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.indicateViewCenterX.isActive = true
            self.layoutIfNeeded()
        }, completion: { if $0 {
            currentLabel.textColor = UIColor(white: 1, alpha: 0.6)
            currentLabel.font = .systemFont(ofSize: 16)
            targetLabel.textColor = UIColor(white: 1, alpha: 1)
            targetLabel.font = .boldSystemFont(ofSize: 16)
            self.currentTag = targetLabel.tag
        } })
        delegate?.pageSegment(selectedIndex: targetLabel.tag)
    }

    func setTitle(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        removeConstraint(indicateViewCenterX)
        let sourceLabel = labels[sourceIndex]
        let targetLabel = labels[targetIndex]

        let totalDistance = targetLabel.centerX - sourceLabel.centerX

        removeConstraint(indicateViewCenterX)
        indicateViewCenterX = indicateView.centerXAnchor.constraint(equalTo: sourceLabel.centerXAnchor, constant: totalDistance * progress)
        indicateViewCenterX.isActive = true

        if progress == 1 {
            if sourceIndex == targetIndex {
                let currentLabel = labels[currentTag]
                currentLabel.textColor = UIColor(white: 1, alpha: 0.6)
                currentLabel.font = .systemFont(ofSize: 16)
            } else {
                sourceLabel.textColor = UIColor(white: 1, alpha: 0.6)
                sourceLabel.font = .systemFont(ofSize: 16)
            }
            targetLabel.textColor = UIColor(white: 1, alpha: 1)
            targetLabel.font = .boldSystemFont(ofSize: 16)
            currentTag = targetIndex
        }
    }
}
