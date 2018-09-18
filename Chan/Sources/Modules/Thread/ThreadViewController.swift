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

private let PostCellIdentifier = "PostCell"

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
    
    // MARK: Data
    private var data: [PostViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupNavBar()
        self.setupCollectionView()
    }
    
    
    private func setupRx() {
        self.listener?.mainViewModel
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
            }).disposed(by: self.disposeBag)
        
        self.listener?.dataSource
            .asObservable()
            .subscribe(onNext: { [weak self] posts in
                self?.data = posts
                self?.collectionView.reloadData()
            }, onError: { [weak self] error in
                
            }).disposed(by: self.disposeBag)
        
        self.cellActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let post = self?.data[idx.item] {
                        self?.listener?.viewActions.on(.next(.openReplys(postUid: post.uid)))
                    }
                }
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupNavBar() {
        let rightNav = UIBarButtonItem(image: .more, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightNav
        rightNav.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
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
        
    }
    
    private func cell(for index: IndexPath) -> UICollectionViewCell {
        let data = self.data[index.item]
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PostCellIdentifier, for: index) as! BasePostCell
        cell.update(with: data)
        cell.action = self.cellActions
        return cell
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
        
        let maxWidth = cellWidth - (PostTextLeftMargin + PostTextRightMargin)
        data.calculateSize(max: maxWidth)
        
        let height = data.height
        return CGSize(width: cellWidth, height: height)

    }
}
