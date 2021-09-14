//
//  MusicListViewController.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

private let CellId = "cell"

class MusicListController: BaseViewController {
    fileprivate var didScroll: ((UIScrollView) -> Void)?

    private var tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let viewModel = MusicListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewModel.loadData {
            self.tableView.reloadData()
        }
    }

    private func setupUI() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MusicViewCell.self, forCellReuseIdentifier: CellId)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.separatorStyle = .none

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// MARK: - UITableViewDataSource

extension MusicListController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 85
    }
}

extension MusicListController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! MusicViewCell
        let cellViewModel = viewModel.list[indexPath.row]
        cell.bind(viewModel: cellViewModel)
        return cell
    }
}

// MARK: - PageContainScrollView

extension MusicListController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}

extension MusicListController: PageContainScrollView {
    func scrollView() -> UIScrollView {
        return tableView
    }

    func scrollViewDidScroll(callBack: @escaping (UIScrollView) -> Void) {
        didScroll = callBack
    }
}
