//
//  ThreadViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

private let PostCellIdentifier = "PostCell"
private let PostMediaCellIdentifier = "PostMediaCell"


protocol ThreadPresentableListener: class {
    var mainViewModel: Variable<PostMainViewModel> { get }
    var dataSource: Variable<[PostViewModel]> { get }
    var viewActions: PublishSubject<PostAction> { get }
}

final class ThreadViewController: BaseViewController, ThreadPresentable, ThreadViewControllable {
    
    // MARK: Other
    weak var listener: ThreadPresentableListener?
    private let disposeBag = DisposeBag()
    private let cellActions: PublishSubject<PostCellAction> = PublishSubject()
    
    // MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let scrollDownButton = ScrollDownButton()

    
    // MARK: Data
    private var data: [PostViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateScrollDownButton()
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupNavBar()
        self.setupCollectionView()
        
        self.view.addSubview(self.scrollDownButton)
        self.scrollDownButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-PostScrollDownButtonRightMargin)
            make.bottom.equalToSuperview().offset(-PostScrollDownButtonBottomMargin)
        }
        
    }
    
    
    private func setupRx() {
        self.listener?.mainViewModel
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
//                self?.refreshControl.isEnabled = model.canRefresh
                
                if model.canRefresh {
                    self?.collectionView.refreshControl = self?.refreshControl
                } else {
                    self?.collectionView.refreshControl = nil
                }
            }).disposed(by: self.disposeBag)
        
        self.listener?.dataSource
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] posts in
                self?.data = posts
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates({
                }, completion: { completed in
                })
                
                self?.updateScrollDownButton()

                self?.endRefresh()

                
                
            }).disposed(by: self.disposeBag)
        
        self.cellActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let post = self?.data[idx.item] {
                        self?.listener?.viewActions.on(.next(.openReplys(postUid: post.uid)))
                    }
                }
                    
                case .tappedAtLink(let url, let cell): do {
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        self?.listener?.viewActions.on(.next(.openLink(postUid: post.uid, url: url)))
                    }
                }
                case .openMedia(let idx, let cell, let view): do {
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        let media = post.media[idx]
//                        if let image = view.image {
//                            let imageInfo = GSImageInfo(image: image, imageMode: GSImageInfo.ImageMode.aspectFit, imageHD: URL(string: MakeFullPath(path: media.path)))
//                            let transitionInfo = GSTransitionInfo(fromView: view)
//                            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
//                            self?.present(imageViewer, animated: true, completion: nil)
//                        }

//                        let loader = SimpleNetworkIntegration()
//                        let axPhoto = AXPhoto(url: URL(string: MakeFullPath(path: media.path)))
//                        let dataSource = AXPhotosDataSource(photos: [axPhoto])
//                        let vc = AXPhotosViewController(dataSource: dataSource, networkIntegration: loader)
////                        vc.
//                        self?.present(vc, animated: true)
                    }
                }

                }
                
            }).disposed(by: self.disposeBag)
        
        self.refreshControl
            .rx
            .controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
                self?.refresh()
            }).disposed(by: self.disposeBag)
        
        self.scrollDownButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.scrollDown()
            }).disposed(by: self.disposeBag)
    }
    
    private func setupNavBar() {
        let rightNav = UIBarButtonItem(image: .more, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightNav
        rightNav.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "Вернуться к треду", style: .default, handler: { [weak self] _ in
                    self?.listener?.viewActions.on(.next(.popToRoot))
                }))

                
                actionSheet.addAction(UIAlertAction(title: "Пожаловаться", style: .destructive, handler: { [weak self] _ in
                    
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] _ in
                    
                }))
                
                self?.present(actionSheet, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func setupCollectionView() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let collectionLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionLayout.minimumInteritemSpacing = PostCellTopMargin
        }
        
        self.collectionView.contentInset = UIEdgeInsets(top: PostCellTopMargin, left: 0, bottom: self.collectionView.contentInset.bottom + PostCellBottomMargin, right: 0)
        
        self.collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCellIdentifier)
        self.collectionView.register(PostMediaCell.self, forCellWithReuseIdentifier: PostMediaCellIdentifier)
    }
    
    private func cell(for index: IndexPath) -> UICollectionViewCell {
        let data = self.data[index.item]
        var cell: UICollectionViewCell
        if data.media.count != 0 {
            cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PostMediaCellIdentifier, for: index)
        } else {
            cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PostCellIdentifier, for: index)
        }
        
        if let cl = cell as? BasePostCellProtocol {
            cl.update(with: data)
            cl.update(action: self.cellActions)
        }
        return cell
    }
    
    private func refresh() {
        self.refreshControl.beginRefreshing()
        
        self.listener?.viewActions.on(.next(.refresh))
    }
    
    private func endRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    private func scrollDown() {
        let offset = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom + self.collectionView.safeAreaInsets.bottom - self.collectionView.frame.height
        if offset > 0 {
            self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: offset), animated: true)
        }
    }
    
    private func updateScrollDownButton() {
        let currentOffset = self.collectionView.contentOffset.y + self.collectionView.frame.height
        let contentSize = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        let delta = PostScrollDownButtonBottomMargin + PostScrollDownButtonSize.height
        if contentSize - currentOffset < delta {
            self.scrollDownButton.hiddenAction.on(.next(true))
        } else {
            self.scrollDownButton.hiddenAction.on(.next(false))
        }
    }
}

extension ThreadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cell(for: indexPath)
    }
}

extension ThreadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = self.data[indexPath.item]
            
        let cellWidth = self.collectionView.frame.width - (PostCellLeftMargin + PostCellRightMargin)
        
        let maxWidth = cellWidth
        data.calculateSize(max: maxWidth)
        
        let height = data.height
        return CGSize(width: cellWidth, height: height)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateScrollDownButton()
    }
}
