//
//  VideoListController.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/28.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit


class VideoListController: BaseViewController {
    fileprivate var didScroll: ((UIScrollView) -> ())?
    
    private let LINE_SPACE: CGFloat = 2
    private let ITEM_SPACE: CGFloat = 1
    private var itemWidth: CGFloat {
        return view.width / 3 - ITEM_SPACE * 2
    }
    
    private var itemHeight: CGFloat {
        return itemWidth * (330.0 / 248.0)
    }
    
    private let VideoListCellId = "VideoListCellId"
    private var collectionView: UICollectionView!
    
    private var viewModel = VideoListViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = LINE_SPACE
        layout.minimumInteritemSpacing = ITEM_SPACE
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoViewCell.self, forCellWithReuseIdentifier: VideoListCellId)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        viewModel.loadUserVideosData() {
            self.collectionView.reloadData()
        }
    }
}

extension VideoListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension VideoListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoListCellId, for: indexPath) as! VideoViewCell
        let cellViewModel = viewModel.list[indexPath.row]
        cell.bind(viewModel: cellViewModel)
        return cell
    }
}



// MARK:- PageContainScrollView
extension VideoListController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}

extension VideoListController: PageContainScrollView {
    func scrollView() -> UIScrollView {
        return collectionView
    }
    
    func scrollViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
        didScroll = callBack
    }
}
