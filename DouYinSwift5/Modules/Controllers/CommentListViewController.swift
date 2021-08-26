//
//  CommentListViewController.swift
//  DouYinSwift5
//
//  Created by lym on 2021/8/26.
//  Copyright © 2021 lym. All rights reserved.
//

import UIKit
/*
    CommentListViewController 的视图层级如下:
    baseView
        effectView 为 UIVisualEffectView 实现模糊效果
        headerView
        tableView
    keyboardMaskView 当键盘弹出时,才显示,用于实现点击上半部分关闭键盘
    commentInputView 底部输入框
 */

class CommentListViewController: UIViewController {
    public var onWillShow: (() -> Void)?
    public var onWillHide: (() -> Void)?

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.backgroundColor = UIColor.black
        containerView.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(pan:)))
        pan.delegate = self
        containerView.addGestureRecognizer(pan)
        return containerView
    }()

    private lazy var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    private lazy var headerView: CommentListViewHeaderView = {
        let headerView = CommentListViewHeaderView()
        headerView.titleLabel.text = "100条评论"
        headerView.closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return headerView
    }()

    private lazy var tableView: CommentListTableView = {
        let tableView = CommentListTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentListViewCell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()

    lazy var topMaskView: UIView = {
        let topMaskView = UIView()
        topMaskView.backgroundColor = UIColor.clear
        topMaskView.isUserInteractionEnabled = true
        topMaskView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        topMaskView.addGestureRecognizer(tap)
        return topMaskView
    }()

    lazy var keyboardMaskView: UIView = {
        let keyboardMaskView = UIView()
        keyboardMaskView.backgroundColor = UIColor.clear
        keyboardMaskView.isUserInteractionEnabled = true
        keyboardMaskView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        keyboardMaskView.addGestureRecognizer(tap)
        return keyboardMaskView
    }()

    lazy var commentInputView: UIView = {
        let commentInputView = UIView()
        commentInputView.backgroundColor = UIColor.clear
        return commentInputView
    }()

    private var panGestureEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        view.backgroundColor = UIColor.clear
        view.isHidden = true
        containerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height * 0.7)
    }
}

extension CommentListViewController {
    @objc func show() {
        onWillShow?()
        topMaskView.isHidden = false
        view.isHidden = false
        let transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.containerView.transform = transform
        })
    }

    @objc func hide() {
        topMaskView.isHidden = true
        let transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.containerView.transform = transform
        }) { finished in
            if finished {
                self.view.isHidden = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let `self` = self else { return }
            self.onWillHide?()
        }
    }
}

extension CommentListViewController {
    private func setupUI() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7, constant: 0).isActive = true

        view.addSubview(topMaskView)
        topMaskView.translatesAutoresizingMaskIntoConstraints = false
        topMaskView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topMaskView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topMaskView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topMaskView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true

        containerView.addSubview(effectView)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        effectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        effectView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        containerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        containerView.addSubview(commentInputView)
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        commentInputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        commentInputView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        commentInputView.heightAnchor.constraint(equalToConstant: 44 + UIWindow.safeAreaInsets.bottom).isActive = true

        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor).isActive = true

        view.addSubview(keyboardMaskView)
        keyboardMaskView.translatesAutoresizingMaskIntoConstraints = false
        keyboardMaskView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        keyboardMaskView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        keyboardMaskView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        keyboardMaskView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor).isActive = true
    }
}

extension CommentListViewController {
    @objc private func closeKeyboard() {
    }

    @objc private func panGestureHandler(pan: UIPanGestureRecognizer) {
        if tableView.isDragging {
            return
        }

        switch pan.state {
        case .began:
            pan.setTranslation(.zero, in: pan.view)

        case .changed:
            let translation = pan.translation(in: pan.view)
            var contentOffset = tableView.contentOffset

            if contentOffset.y > 0 {
                // 这段代码用于处理, tableView 已经往上滑动一部分后
                // 从 headerView 区域 触发手势, 无法滑动 tableView
                // 还有另一个功能就是,用于修正 tableView
                contentOffset.y -= translation.y
                pan.setTranslation(.zero, in: pan.view)
                tableView.setContentOffset(contentOffset, animated: false)
                return
            }
            // 如果去掉这段代码,会出现 突然往下跳动, 具体现象可以,注释掉这部分代码
            if contentOffset.y == 0.0 && !panGestureEnable {
                panGestureEnable = true
                pan.setTranslation(.zero, in: pan.view)
                return
            }
            updatePresentedViewForTranslation(translation.y)

        case .ended, .failed:
            panGestureEnable = false
            let curTransform = containerView.transform
            let transform = CGAffineTransform.identity
            // 200 这个临界值可以修改合适的值
            if curTransform.ty >= 100 {
                hide()
            } else {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                    self.containerView.transform = transform
                })
            }

        default:
            break
        }
    }

    private func updatePresentedViewForTranslation(_ translation: CGFloat) {
        if translation < 0 {
            containerView.transform = .identity
            tableView.setContentOffset(CGPoint(x: 0, y: -translation), animated: false)
            return
        }
        containerView.transform = CGAffineTransform(translationX: 0, y: translation)
    }
}

extension CommentListViewController: UIScrollViewDelegate {
    // 关键点: 当 tableView 下滑到顶以后, 交由 containerView 的手势处理
    // 这样就不需要下滑到顶以后,需要松开手指 再次触发手势
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -scrollView.contentInset.top && scrollView.panGestureRecognizer.state == .changed {
            print("tableview top")
            scrollView.panGestureRecognizer.state = .ended
            scrollView.setContentOffset(.zero, animated: false)
            return
        }
    }
}

extension CommentListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 关键点: 允许同时识别多个手势
        return true
    }
}

extension CommentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListViewCell", for: indexPath)
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.text = String(indexPath.row)
        cell.textLabel?.textColor = .white
        return cell
    }
}

extension CommentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = UserPageViewController()
        UIWindow.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
