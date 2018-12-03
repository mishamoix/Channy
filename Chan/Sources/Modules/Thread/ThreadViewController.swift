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
import AVKit
import KafkaRefresh
//import KRPullLoader


let ThreadAvailableContextMenu = ["copyLink", "copyOrigianlText", "copyText", "screenshot"]


private let PostCellIdentifier = "PostCell"
private let PostMediaCellIdentifier = "PostMediaCell"


protocol ThreadPresentableListener: class {
    var mainViewModel: Variable<PostMainViewModel> { get }
    var dataSource: Variable<[PostViewModel]> { get }
    var viewActions: PublishSubject<PostAction> { get }
    var moduleIsRoot: Bool { get }
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
    private let scrollUpButton = ScrollDownButton()
    private var writeButton: UIBarButtonItem? = nil
    
    
//    private let topRefresher = KRPullLoadView()
//    private let bottomRefresher = KRPullLoadView()

    private var currentWidth: CGFloat = 0
    private var savedIndexForRotate: IndexPath? = nil

    // MARK: Data
    private var data: [PostViewModel] = []
    var autosctollUid: String? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateScrollDownButton()
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let target = self.collectionView.contentOffset.y
        var result: CGFloat = 0
        for (i, item) in self.data.enumerated() {
            result += PostCellTopMargin
            result += item.height
            if result > target {
                self.savedIndexForRotate = IndexPath(item: i, section: 0)
                break
            }
        }
        
        self.currentWidth = size.width
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.layoutSubviews()
        
        for visibleCell in self.collectionView.visibleCells {
            if let idx = self.collectionView.indexPath(for: visibleCell) {
                if let cell = visibleCell as? BasePostCellProtocol {
                    cell.update(with: self.data[idx.item])
                }
            }
        }
    }
    
    // MARK: ThreadPresentable
//    func needAutoscroll(to uid: String) {
//
//    }
    
    func scrollToLast() {
        self.collectionView.setContentOffset(CGPoint(x: 0, y: max(self.collectionView.contentSize.height - self.collectionView.frame.height, 0)), animated: true)
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
        
        self.setupTheme()
    }
    
    
    private func setupRx() {
        self.listener?.mainViewModel
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
                
                self?.setupRefreshers(can: model.canRefresh)
                
                if model.canRefresh {
                    if #available(iOS 10.0, *) {
                        self?.collectionView.refreshControl = self?.refreshControl
                    } else {
                        if let refresher = self?.refreshControl {
                            self?.collectionView.addSubview(refresher)
                        }
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        self?.collectionView.refreshControl = nil
                    } else {
                        self?.refreshControl.removeFromSuperview()
                    }
                }
            }).disposed(by: self.disposeBag)
        
        self.listener?.dataSource
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] posts in
                guard let self = self else { return }
                self.data = posts
                
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates({}, completion: nil)
                
                if let autosctollUid = self.autosctollUid, let idx = posts.firstIndex(where: { $0.uid == autosctollUid }) {
                    self.autosctollUid = nil
                    self.collectionView.scrollToItem(at: IndexPath(item: idx, section: 0), at: .top, animated: true)
                }

                self.updateScrollDownButton()
            }).disposed(by: self.disposeBag)
        
        self.cellActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let post = self?.data[idx.item] {
                        self?.listener?.viewActions.on(.next(.openReplys(postUid: post.uid)))
                    }
                }
                    
                case .reply(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let post = self?.data[idx.item] {
                        self?.listener?.viewActions.on(.next(.reply(postUid: post.uid)))
                    }
                }
                    
                case .tappedAtLink(let url, let cell): do {
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        self?.listener?.viewActions.on(.next(.openLink(postUid: post.uid, url: url)))
                    }
                }
                case .openMedia(let idx, let cell, _): do {
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        let media = post.media[idx]
                        
                        if FirebaseManager.shared.disableImages {
                            ErrorDisplay.presentAlert(with: "Ошибка доступа", message: "Медиа отключено по требованию Apple", styles: [.ok])
//                        }
                        } else {
                            self?.listener?.viewActions.on(.next(.open(media: media)))
                        }
                    }
                }
                    
                case .copyOriginalText(let cell):
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        self?.listener?.viewActions.on(.next(.copyPost(postUid: post.uid)))
                    }

                case .copyText(let cell):
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        self?.listener?.viewActions.on(.next(.cutPost(postUid: post.uid)))
                    }
                    
                case .copyMediaLink(let cell, let idx):
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item], post.media.count > idx {
                        self?.listener?.viewActions.on(.next(.copyMedia(media: post.media[idx])))
                    }
                    
                case .copyPostLink(let cell):
                    if let i = self?.collectionView.indexPath(for: cell), let post = self?.data[i.item] {
                        self?.listener?.viewActions.on(.next(.copyLinkPost(postUid: post.uid)))
                    }
                }
                
            })
            .disposed(by: self.disposeBag)
        
        self.refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.refresh()
            })
            .disposed(by: self.disposeBag)
        
        self.scrollDownButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.scrollDown()
            })
            .disposed(by: self.disposeBag)
        
        self.scrollUpButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.scrollUp()
            })
            .disposed(by: self.disposeBag)
        
        if let listener = self.listener {
            self.writeButton?
                .rx
                .tap
                .asObservable()
                .map({ _ -> PostAction in
                    return .replyThread
                })
                .bind(to: listener.viewActions)
                .disposed(by: self.disposeBag)
        }
    }
    
    private func setupTheme() {
        
        self.themeManager.append(view: ThemeView(view: self.collectionView, type: .collection, subtype: .none))
        
    }
    
    private func setupNavBar() {
        let rightNav = UIBarButtonItem(image: .more, style: .plain, target: nil, action: nil)
        self.themeManager.append(view: ThemeView(object: rightNav, type: .navBarButton, subtype: .none))
        rightNav.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
              
                if self?.listener?.moduleIsRoot ?? false {
                    
                    actionSheet.addAction(UIAlertAction(title: "Скопировать ссылку на тред", style: .default, handler: { [weak self] _ in
                        self?.listener?.viewActions.on(.next(.copyLinkOnThread))
                    }))
                    
//                    actionSheet.addAction(UIAlertAction(title: "Ответить в тред", style: .default, handler: { [weak self] _ in
//                        self?.listener?.viewActions.on(.next(.replyThread))
//                    }))
                    
                    actionSheet.addAction(UIAlertAction(title: "Пожаловаться", style: .destructive, handler: { [weak self] _ in
                        self?.reportThread()
                    }))
                } else {
                    actionSheet.addAction(UIAlertAction(title: "Вернуться к треду", style: .default, handler: { [weak self] _ in
                        self?.listener?.viewActions.on(.next(.popToRoot))
                    }))
                }
                
                actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                
                self?.present(actionSheet, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        if self.listener?.moduleIsRoot ?? false {
            let writeButton = UIBarButtonItem(image: .write, landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: nil, action: nil)
            let inset: CGFloat = 6
//            writeButton.imageInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
            self.writeButton = writeButton
            
            self.navigationItem.rightBarButtonItems = [rightNav, writeButton]
            
        } else {
            self.navigationItem.rightBarButtonItem = rightNav
        }
    }
    
    private func setupCollectionView() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let collectionLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionLayout.minimumInteritemSpacing = PostCellTopMargin
        }
        
        self.collectionView.contentInset = UIEdgeInsets(top: PostCellTopMargin, left: 0, bottom: self.collectionView.contentInset.bottom + PostCellBottomMargin, right: 0)
        
        if #available(iOS 11.0, *) {} else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCellIdentifier)
        self.collectionView.register(PostMediaCell.self, forCellWithReuseIdentifier: PostMediaCellIdentifier)
    }
    
    private func setupRefreshers(can refresh: Bool) {
        
        
        if refresh {
            if self.refreshControl.superview == nil {
                if #available(iOS 10.0, *) {
                    self.collectionView.refreshControl = self.refreshControl
                } else {
                    self.collectionView.addSubview(self.refreshControl)
                }
//                self.collectionView.bindHeadRefreshHandler({ [weak self] in
//                    self?.refresh()
//                }, themeColor: self.themeManager.theme.main, refreshStyle: KafkaRefreshStyle.native)
//
//
//                if let refreshControl = self.collectionView.headRefreshControl.value(forKey: "_indicator") as? UIActivityIndicatorView {
//                    refreshControl.color = self.themeManager.theme.main
//                }
            }
            
            if self.collectionView.footRefreshControl == nil {
                self.collectionView.bindFootRefreshHandler({ [weak self] in
                    self?.refresh()
                }, themeColor: self.themeManager.theme.main, refreshStyle: KafkaRefreshStyle.native)
                
                
                if let refreshControl = self.collectionView.footRefreshControl.value(forKey: "_indicator") as? UIActivityIndicatorView {
                    refreshControl.color = UIColor.refreshControl
                }
            }
        } else {
            self.refreshControl.removeFromSuperview()
            self.collectionView.footRefreshControl?.removeFromSuperview()
        }
//        self.collectionView.configRefreshFooter(container: self as AnyObject) { [weak self] in
//            self?.refresh()
//        }
//
//        self.collectionView.configRefreshFooter(container: self as AnyObject) {[weak self] in
//            self?.refresh()
//        }
//
//        self.topRefresher.messageLabel.text = "Обновляем"
//        self.bottomRefresher.messageLabel.text = "Обновляем"
//        self.topRefresher.delegate = self
//        self.bottomRefresher.delegate = self
//
//        if refresh {
//            self.collectionView.addPullLoadableView(self.topRefresher, type: .refresh)
//            self.collectionView.addPullLoadableView(self.bottomRefresher, type: .loadMore)
//        } else {
//            self.topRefresher.removeFromSuperview()
//            self.bottomRefresher.removeFromSuperview()
//        }
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
//        self.refreshControl.beginRefreshing()
        
        self.listener?.viewActions.on(.next(.refresh))
    }
    
    private func endRefresh() {
//        self.refreshControl.endRefreshing()
    }
    
    private func scrollDown() {
        var offset: CGFloat = 0
        if #available(iOS 11.0, *) {
            offset = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom + self.collectionView.safeAreaInsets.bottom - self.collectionView.frame.height
        } else {
            offset = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom - self.collectionView.frame.height
        }
        if offset > 0 {
            self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: offset), animated: true)
        }
    }
    
    private func scrollUp() {

        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: 0), animated: true)
        
    }
    
    private func updateScrollDownButton() {
        let currentOffset = self.collectionView.contentOffset.y + self.collectionView.frame.height
        let contentSize = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        let delta = PostScrollDownButtonBottomMargin + PostScrollDownButtonSize.height
        if contentSize - currentOffset < delta {
            self.scrollDownButton.hiddenAction.on(.next(true))
            self.scrollUpButton.hiddenAction.on(.next(true))
        } else {
            self.scrollDownButton.hiddenAction.on(.next(false))
            self.scrollUpButton.hiddenAction.on(.next(false))

        }
    }
  
    private func reportThread() {
        self.listener?.viewActions.on(.next(.reportThread))
        ErrorDisplay.presentAlert(with: "Жалоба отправлена", message: "Жалоба будет рассмотрена в течении 24 часов", dismiss: DefaultDismissTime)
    }
}

extension ThreadViewController: RefreshingViewController {
    var refresher: UIRefreshControl? {
        return nil
    }
    
    
    func stopAllRefreshers() {
        
        self.collectionView.footRefreshControl?.endRefreshing()
        self.refreshControl.endRefreshing()
        
    }
}

extension ThreadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cell(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return ThreadAvailableContextMenu.contains(action.description)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let post = self.data[indexPath.row]
        if action.description == "copyText" {
            self.listener?.viewActions.on(.next(.copyPost(postUid: post.uid)))
        } else if action.description == "copyOrigianlText" {
            self.listener?.viewActions.on(.next(.cutPost(postUid: post.uid)))
        }
    }

}

extension ThreadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.currentWidth == 0 {
            self.currentWidth = self.collectionView.frame.width
        }
        
        let data = self.data[indexPath.item]
            
        let cellWidth = self.currentWidth - (PostCellLeftMargin + PostCellRightMargin)
        
        let maxWidth = cellWidth
        data.calculateSize(max: maxWidth)
        
        let height = data.height
        return CGSize(width: cellWidth, height: height)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateScrollDownButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let oldCenter = self.savedIndexForRotate else {
            return proposedContentOffset
        }
        self.savedIndexForRotate = nil
        
        let attrs = collectionView.layoutAttributesForItem(at: oldCenter)
        if let newFrame = attrs?.frame {
            return CGPoint(x: 0, y: newFrame.minY)
        }
        return proposedContentOffset


        
//        if let centerCellIdx = self.savedIndexForRotate {
//            self.savedIndexForRotate = nil
//            if let centerCellFrame = self.collectionView.layoutAttributesForItem(at: centerCellIdx)?.frame {
//                let b = centerCellFrame.minY - self.collectionView.frame.height / 2.0
//                return CGPoint(x: 0, y: centerCellFrame.origin.y)
//            }
//
//        }
//
//        return CGPoint(x: 0, y: 0)
    }
}

//extension ThreadViewController: KRPullLoadViewDelegate {
//    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
//        switch state {
//        case .loading(_): self.refresh()
//        default: break
//        }
//    }
//}
