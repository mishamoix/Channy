//
//  BoardViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import IGListKit
import SnapKit

let ThreadCellIdentifier = "ThreadCell"
let AdThreadCellIdentifier = "AdThreadCell"


protocol BoardPresentableListener: class {

    var mainViewModel: Variable<BoardMainViewModel> { get }
    var dataSource: Variable<[ThreadViewModel]> { get }
    var viewActions: PublishSubject<BoardAction> { get }
    
    var updateSearchObservable: Variable<String?> { get }
}

final class BoardViewController: BaseViewController, BoardPresentable, BoardViewControllable {

    
    // MARK: Other
    weak var listener: BoardPresentableListener?
    var vc: UIViewController { return self }
    var isVisible: Bool { return self.viewIfLoaded?.window != nil }


    private let disposeBag = DisposeBag()
    private var cellActions: PublishSubject<BoardCellAction> = PublishSubject()
    
    // MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    weak var addBoardButton: UIBarButtonItem?
    weak var moreButton: UIBarButtonItem?
    weak var homeButton: UIButton?
    weak var createNewThreadButton: UIButton?
    
    private var rightNavbarLabel: UILabel? = nil
    private var leftNavbarLabel: UILabel? = nil
    private let searchController = UISearchController(searchResultsController: nil)

    
    // MARK: Data
    private var data: [ThreadViewModel] = []
    private var tableWidth: CGFloat = 0
    
    private var mainViewModel: BoardMainViewModel? = nil
    
    private var needStopLoadersAfterRefresh = false
    
    
    // MARK: Main
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listener?.viewActions.on(.next(.viewWillAppear))
        
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableWidth = self.collectionView.frame.width
        if let nc = self.navigationController as? BaseNavigationController {
            nc.interactivePopPanGestureRecognizer?.isEnabled = false
        }
        
//        self.updateRightLabel(hide: false)
//        self.updateLargeTitleSize()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nc = self.navigationController as? BaseNavigationController {
            nc.interactivePopPanGestureRecognizer?.isEnabled = true
        }
        
//        self.updateRightLabel(hide: true)
      
//        self.largeTitle?.alpha = 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        coordinator.animate(alongsideTransition: { context in
//            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in
//            self.collectionView.layoutSubviews()
        }
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.updateLargeTitleSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.updateLargeTitleSize()

    }
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
////        if self.skipKVOLargeTitleFrame {
////            self.skipKVOLargeTitleFrame = false
////            return
////        }
//        self.updateLargeTitleSize()
//    }
    
    // MARK: BoardPresentable
    func stopLoadersAfterRefresh() {
        self.needStopLoadersAfterRefresh = true
    }
    
    var serachActive: Bool {
        return self.searchController.isActive
    }
    
    func scrollToTop() {
        if #available(iOS 11.0, *) {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -self.collectionView.adjustedContentInset.top), animated: true)
        } else {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: self.collectionView.contentInset.top), animated: true)

            // Fallback on earlier versions
        }
    }

    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupCollectionView()
        self.setupNavBar()
        self.setupTheme()
    }
    
    private func setupRx() {
        self.listener?
            .mainViewModel
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                if let rightLabel = self.rightNavbarLabel {
                    self.navigationItem.title = model.name
                    rightLabel.text = model.board
//                    self.rightNavbarLabel?.text = model.name
                    self.leftNavbarLabel?.text = model.name
                    self.mainViewModel = model
//                    self.updateLargeTitleSize()

                } else {
                    self.navigationItem.title = "\(model.name) \(model.board)"

                }
            }).disposed(by: self.disposeBag)
        
        self.listener?
            .dataSource
            .asObservable()
//            .debug()
            .map({ [weak self] models -> [ThreadViewModel] in
                return models.map { $0.calculateSize(max: self?.tableWidth ?? 0) }
            })
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] result in                
                guard let self = self else { return }
                let oldData = self.data
//                let collectionView = self?.collectionView
//                    let diff = ListDiff(oldArray: oldData, newArray: result, option: .equality)
                let diff = ListDiffPaths(fromSection: 0, toSection: 0, oldArray: oldData, newArray: result, option: .equality)
                self.data = result
                
                let movesNotNull = diff.moves.count != 0
                let otherNotNull = (diff.updates.count + diff.deletes.count + diff.inserts.count) != 0
                
                if (movesNotNull && !otherNotNull || !movesNotNull) {
                
                    self.collectionView.performBatchUpdates({
                        for move in diff.moves {
                            self.collectionView.moveItem(at: move.from, to: move.to)
                        }

                        self.collectionView.deleteItems(at: diff.deletes)
                        self.collectionView.insertItems(at: diff.inserts)
                        self.collectionView.reloadItems(at: diff.updates)

                    }, completion: { finished in
                        self.stopLoadersIfNeeded()
                    })
                    
                    return
                    
                }
                
                self.collectionView.reloadData()
                self.stopLoadersIfNeeded()
                
            })
            .disposed(by: self.disposeBag)
        
        self.cellActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .tapped(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let model = self?.data[idx.row] {
                        self?.listener?.viewActions.on(.next(.openThread(uid: model.uid)))
                    }
                }
                case .starTapped(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell), let model = self?.data[idx.row] {
                        self?.listener?.viewActions.on(.next(.addToFavorites(uid: model.uid)))
                    }
                }
                }
            }).disposed(by: self.disposeBag)
        
        self.refreshControl
            .rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.listener?.viewActions.on(.next(.reload))
            }).disposed(by: self.disposeBag)
        
        self.moreButton?
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//
                if IsIpad {
                    actionSheet.popoverPresentationController?.barButtonItem = self?.moreButton
                }
//
//                actionSheet.addAction(UIAlertAction(title: "Скопировать ссылку на доску", style: .default, handler: { [weak self] _ in
//                    self?.listener?.viewActions.on(.next(.copyLinkOnBoard))
//                }))
//
//                actionSheet.addAction(UIAlertAction(title: "Открыть по ссылке", style: .default, handler: { [weak self] _ in
//                    self?.listener?.viewActions.on(.next(.openByLink))
//                }))
                
//                actionSheet.addAction(UIAlertAction(title: "Создать тред", style: .default, handler: { [weak self] _ in
//                    self?.listener?.viewActions.on(.next(.createNewThread))
//                }))

                actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                
                self?.present(actionSheet, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.homeButton?
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.listener?.viewActions.on(.next(.openHome))
            })
            .disposed(by: self.disposeBag)
        
        self.createNewThreadButton?
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.listener?.viewActions.on(.next(.createNewThread))
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
    private func setupCollectionView() {
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.register(UINib(nibName: ThreadCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ThreadCellIdentifier)
//        self.collectionView.register(AdThreadCell.self, forCellWithReuseIdentifier: AdThreadCellIdentifier)
        self.collectionView.register(UINib(nibName: AdThreadCellIdentifier, bundle: nil), forCellWithReuseIdentifier: AdThreadCellIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableWidth = self.collectionView.frame.width
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: DefaultMargin, left: 0, bottom: DefaultMargin, right: 0)
        self.collectionView.keyboardDismissMode = .onDrag
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.01
            layout.minimumInteritemSpacing = 0.01
        }
    }
    
    private func setupNavBar() {
      
        if #available(iOS 11.0, *) {
            let navbar = self.navigationController?.navigationBar
            self.extendedLayoutIncludesOpaqueBars = true
            if let navbar = navbar {
                navbar.prefersLargeTitles = true
                
                self.navigationItem.largeTitleDisplayMode = .automatic
                
                let rightNavbarLabel = UILabel()
                rightNavbarLabel.font = .largeSubtitle
//                rightNavbarLabel.text = "/b"
                
                let leftNavbarLabel = UILabel()
                leftNavbarLabel.font = .largeTitle
//                leftNavbarLabel.text = "welcome".localized
                if let largeTitleView = self.largeTitleView {
                    largeTitleView.addSubview(rightNavbarLabel)
                    largeTitleView.addSubview(leftNavbarLabel)
                    
                    self.leftNavbarLabel = leftNavbarLabel
                    self.rightNavbarLabel = rightNavbarLabel

                    rightNavbarLabel.snp.makeConstraints { make in
                        make.right.equalToSuperview().offset(-BoardConstants.NavbarRightLabelRightMargin)
                        make.bottom.equalToSuperview().offset(-BoardConstants.NavbarRightLabelBottomMargin)
                        make.left.greaterThanOrEqualTo(leftNavbarLabel.snp.right).offset(BoardConstants.NavbarRightLabelLeftMargin)
                    }
                    
                    leftNavbarLabel.snp.makeConstraints { make in
//                        make.edges.equalToSuperview()
                        make.bottom.equalToSuperview().offset(-BoardConstants.NavbarRightLabelBottomMargin)
                        make.left.equalToSuperview().offset(BoardConstants.NavbarLeftLabelLeftMargin)
                    }
                    
                    navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
                    
                    leftNavbarLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: NSLayoutConstraint.Axis.horizontal)
                }
                
                self.navigationItem.hidesBackButton = true
//                let search = UISearchController(searchResultsController: nil)
                self.searchController.searchResultsUpdater = self
                self.navigationItem.searchController = self.searchController
                self.searchController.obscuresBackgroundDuringPresentation = false
                self.searchController.hidesNavigationBarDuringPresentation = false
                
                self.leftNavbarLabel?.text = "welcome".localized
                self.rightNavbarLabel?.text = "/b"
                
            }
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.addSubview(self.refreshControl)
        }

      
      
        let more = UIBarButtonItem(image: .more, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.themeManager.append(view: ThemeView(object: more, type: ThemeViewType.navBarButton, subtype: .none))
        self.moreButton = more

        let inset: CGFloat = 4
        let writeButton = UIButton()
        writeButton.setImage(.addThread, for: .normal)
        writeButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        writeButton.tintColor = self.themeManager.theme.accnt
        writeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.createNewThreadButton = writeButton
//        let writeBarButton = UIBarButtonItem(customView: writeButton)

        let homeCanvas = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let homeButton = UIBarButtonItem(customView: homeCanvas)

//        self.navigationItem.setRightBarButtonItems([more], animated: false)
        self.navigationItem.setLeftBarButtonItems([homeButton], animated: false)

        let home = UIButton(frame: .zero)
        home.setImage(.home, for: .normal)
        home.tintColor = .main
        homeCanvas.addSubview(home)

        self.themeManager.append(view: ThemeView(object: home, type: .navBarButton, subtype: .none))

        home.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        self.homeButton = home
    }
    
    override func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.collectionView, type: .cell, subtype: .none))
        self.themeManager.append(view: ThemeView(view: self.rightNavbarLabel, type: .text, subtype: .third))
        self.themeManager.append(view: ThemeView(view: self.leftNavbarLabel, type: .text, subtype: .none))
        self.themeManager.append(view: ThemeView(view: self.searchController.searchBar, type: .input, subtype: .none))
    }
    
    private func updateRightLabel(hide: Bool = false) {
//        return
//        UIView.animate(withDuration: 0) {
//            self.rightNavbarLabel?.alpha = hide ? 0 : 1
//        }
        
    }
    
    private var largeTitleView: UIView? {
        for subview in self.navigationController?.navigationBar.subviews ?? [] {
            if NSStringFromClass(type(of: subview)) == "_UINavigationBarLargeTitleView" {
                return subview
            }
        }
        return nil
    }
    
    private var largeTitleOriginal: UIView? {
        for subview in self.largeTitleView?.subviews.filter({ $0.isKind(of: UILabel.self)}) ?? [] {
            return subview
        }
        
        return nil
    }
    
    private func stopLoadersIfNeeded() {
        if self.needStopLoadersAfterRefresh {
            self.stopAnyLoaders()
            self.needStopLoadersAfterRefresh = false
        }
    }

    
//    private func updateLargeTitleSize() {
//        if let largeTitle = self.largeTitle, let rightLabel = self.rightNavbarLabel {
//
//            largeTitle.snp.remakeConstraints { make in
//            }
//
//            let rightLabelWidth = TextSize(text: rightLabel.text ?? "", maxWidth: CGFloat.infinity, font: rightLabel.font).calculate().width
//            let width = TextSize(text: self.mainViewModel?.name ?? "", maxWidth: self.view.frame.width - largeTitle.frame.minX - BoardConstants.NavbarRightLabelRightMargin - BoardConstants.NavbarRightLabelLeftMargin - rightLabelWidth, font: .largeTitle).calculate().width
//            largeTitle.frame = CGRect(x: largeTitle.frame.minX, y: largeTitle.frame.minY, width: width, height: largeTitle.frame.height)
//        }
//    }
    
    
  
}

extension BoardViewController: RefreshingViewController {
    func stopAllRefreshers() {}
    
    var refresher: UIRefreshControl? {
        return self.refreshControl
    }
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.data[indexPath.row].height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        self.listener?.viewActions.on(.next(.openThread(uid: model.uid)))
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.data[indexPath.row].height
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView(self.tableView, heightForRowAt:indexPath)
//    }
//
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentSize.height - (self.collectionView.contentOffset.y + self.collectionView.frame.height) < ThreadTableLoadNext {
            self.listener?.viewActions.on(.next(.loadNext))
        }
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.deselectRow(at: indexPath, animated: true)
//
//        self.listener?.viewActions.on(.next(.openThread(idx: indexPath.row)))
//    }

}

extension BoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.data[indexPath.row]
        if data.type == .thread {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreadCellIdentifier, for: indexPath)
            if let c = cell as? ThreadCell {
                c.update(with: data)
                c.actions = self.cellActions
                c.delegate = self
            }
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdThreadCellIdentifier, for: indexPath)
            if let c = cell as? AdThreadCell, let data = data as? AdsThreadViewModel {
                data.updateAdBannerLoader(with: self)
                c.update(model: data, vc: self)
            }
            
            return cell
        }
        

    }
//    collectionViewItemFor
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = self.data[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: ThreadCellIdentifier, for: indexPath)
//        if let c = cell as? ThreadCell {
//            c.update(with: data)
//            c.actions = self.cellActions
//        }
//        return cell
//    }
}


extension BoardViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        let options = SwipeOptions()
        
//        options.cancelGestureRecognizerForEmptySwipeActions
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let bgColor = ThemeManager.shared.theme.background
        
        if orientation == .left {
//            self.listener?.viewActions.on(.next(.openHome))
            return nil
        }
        
        let title = self.data[indexPath.row].favorited ? "delete_from_favorite".localized : "add_to_favorite".localized
        
        let toFavorites = SwipeAction(style: .default, title: title) { [weak self] (action, indexPath) in
            
            guard let self = self else { return }
            
            self.listener?.viewActions.on(.next(.addToFavorites(uid: self.data[indexPath.row].uid)))
            
//            let data = self.data[indexPath.item]
//            data.favorited = !data.favorited
//
//            let _ = self.collectionView(self.collectionView, cellForItemAt: indexPath)
            
        }
        toFavorites.image = .addFavorite
        toFavorites.backgroundColor = bgColor
        toFavorites.textColor = ThemeManager.shared.theme.text
        toFavorites.tintColor = ThemeManager.shared.theme.text
//        toFavorites.hidesWhenSelected = true
        
        
        let hidePost = SwipeAction(style: .default, title: "Скрыть") { [weak self] (action, indexPath) in
            if let model = self?.data[indexPath.row] {
                self?.listener?.viewActions.on(.next(.hide(uid: model.uid)))
            }
        }
        hidePost.image = .hide
        hidePost.backgroundColor = bgColor
//        hidePost.hidesWhenSelected = true
        
        return [toFavorites]

    }
    
}


extension BoardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.listener?.updateSearchObservable.value = searchController.searchBar.text
    }
}
