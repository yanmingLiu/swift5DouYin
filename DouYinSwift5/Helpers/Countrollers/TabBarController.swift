//
//  TabBarController.swift
//  DouYinSwift5
//
//  Created by ym L on 2020/7/23.
//  Copyright © 2020 ym L. All rights reserved.
//

import UIKit

// MARK: - TabBarController

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
        customTabBar.setSelected(selected: true, index: selectedIndex)
    }
}

class TabBarController: UITabBarController {
    var customTabBar = TabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewControllers()
        delegate = self
    }

    func configViewControllers() {
        let childClassNames = [
            ["vc": "VideoFeedController", "title": "首页", "count": 0],
            ["vc": "TimeLineController", "title": "关注", "count": 0],
            ["vc": "", "image": "btn_home_add75x49", "count": 0],
            ["vc": "", "title": "消息", "count": 0],
            ["vc": "", "title": "我", "count": 0],
        ]

        var childVCs: [UIViewController] = []
        var childItem: [TabbarItem] = []
        childClassNames.forEach { dict in
            childVCs.append(buildViewController(from: dict))
            childItem.append(buildTabbarItem(from: dict))
        }

        viewControllers = childVCs

        customTabBar.tabItems = childItem
        setValue(customTabBar, forKey: "tabBar")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.customTabBar.setCount(count: 18, index: 3)
        }
    }

    func buildViewController(from conf: [String: Any]) -> UIViewController {
        guard let className = conf["vc"],
              let vcCls = NSClassFromString(Bundle.appBundleName + ".\(className)") as? UIViewController.Type
        else {
            let temp = BaseViewController()
            let navVC = NavigationController(rootViewController: temp)
            return navVC
        }
        let viewController = vcCls.init()
        let navVC = NavigationController(rootViewController: viewController)
        return navVC
    }

    func buildTabbarItem(from conf: [String: Any]) -> TabbarItem {
        guard let name = conf["title"] else {
            guard let image = conf["image"] else {
                return TitleItem(title: "未知")
            }
            return AddItem(image: image as! String)
        }
        return TitleItem(title: name as! String, count: conf["count"] as! Int)
    }
}

// MARK: - TabBar

class TabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundImage = UIImage()
        shadowImage = UIImage()

        isTranslucent = false
        barTintColor = themeColor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSelected(selected _: Bool, index: Int) {
        guard let items = tabItems else { return }
        for (i, item) in items.enumerated() {
            if i == index {
                item.selectedStatus = true
            } else {
                item.selectedStatus = false
            }
        }
    }

    public func setCount(count: Int, index: Int) {
        guard let items = tabItems else { return }

        let item = items[index]
        if item is TitleItem {
            (item as! TitleItem).count = count
        }
    }

    var tabItems: [TabbarItem]? {
        didSet {
            guard let items = tabItems else {
                return
            }
            removeSubviews()
            items.forEach {
                if $0 is TitleItem {
                    addSubview($0)
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let items = tabItems else { return }
        let itemW = width / CGFloat(items.count)
        let itemH = height - CGFloat(UIWindow.key?.safeAreaInsets.bottom ?? 0.0)
        for (index, item) in items.enumerated() {
            if item.frame != CGRect.zero { return }
            if index == 0 {
                item.selectedStatus = true
            }
            if item is TitleItem {
                item.frame = CGRect(x: itemW * CGFloat(index), y: 0, width: itemW, height: itemH)
            } else if item is AddItem {
                addSubview(item)
                item.frame = CGRect(x: itemW * CGFloat(index), y: 0, width: itemW, height: itemH)
            }
        }
    }
}

// MARK: - TabBar item

protocol TabbarItem: UIView {
    var selectedStatus: Bool { get set }
    var count: Int { get set }
}

class AddItem: UIControl, TabbarItem {
    var image: UIImageView

    var count: Int
    var selectedStatus: Bool = false

    init(image: String) {
        self.image = UIImageView(image: UIImage(named: image))
        count = 0
        super.init(frame: CGRect.zero)
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.1) {
            self.image.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        return super.beginTracking(touch, with: event)
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        UIView.animate(withDuration: 0.1) {
            self.image.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        UIView.animate(withDuration: 0.1) {
            self.image.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

class TitleItem: UIView, TabbarItem {
    var button: UIButton!
    var indicatorView: UIView!
    var badge: PaddingLabel!
    var title: String = ""

    var count: Int = 0 {
        didSet {
            badge.isHidden = count <= 0
            badge.text = "\(count)"
        }
    }

    var selectedStatus: Bool = false {
        didSet {
            if selectedStatus {
                button.isSelected = true
                indicatorView.isHidden = false
            } else {
                button.isSelected = false
                indicatorView.isHidden = true
            }
        }
    }

    init(title: String, count: Int = 0) {
        self.title = title
        self.count = count
        super.init(frame: CGRect.zero)
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        let normalStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: tabBarNormalFont, NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        button.setAttributedTitle(normalStr, for: .normal)
        let selectedStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: tabBarSelectFont, NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(selectedStr, for: .selected)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.white
        indicatorView.layer.cornerRadius = 1
        addSubview(indicatorView)
        indicatorView.isHidden = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        guard let title = button.title(for: .normal) else { return }
        let titleW = title.width(for: tabBarSelectFont)
        indicatorView.widthAnchor.constraint(equalToConstant: titleW).isActive = true

        badge = PaddingLabel(frame: .zero)
        badge.padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        badge.isHidden = true
        badge.textColor = themeColor
        badge.backgroundColor = badgeColor
        badge.font = .boldSystemFont(ofSize: 10)
        badge.clipsToBounds = true
        badge.cornerRadius = 8
        badge.textAlignment = .center
        badge.sizeToFit()
        addSubview(badge)
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 16).isActive = true
        badge.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -5).isActive = true
        badge.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
}
