//
//  TimeLineController.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

class TimeLineController: BaseViewController {
    fileprivate var didScroll: ((UIScrollView) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - PageContainScrollView

extension TimeLineController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}

extension TimeLineController: PageContainScrollView {
    func scrollView() -> UIScrollView {
        return UIScrollView()
    }

    func scrollViewDidScroll(callBack: @escaping (UIScrollView) -> Void) {
        didScroll = callBack
    }
}
