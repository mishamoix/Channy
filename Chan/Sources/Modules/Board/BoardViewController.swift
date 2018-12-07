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

let ThreadCellIdentifier = "ThreadCell"


protocol BoardPresentableListener: class {

    var mainViewModel: Variable<BoardMainViewModel> { get }
    var dataSource: Variable<[ThreadViewModel]> { get }
    var viewActions: PublishSubject<BoardAction> { get }
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
    @IBOutlet weak var bgImage: UIImageView!
    
    weak var addBoardButton: UIBarButtonItem?
    weak var moreButton: UIBarButtonItem?
    weak var homeButton: UIButton?
    weak var createNewThreadButton: UIButton?
    
    // MARK: Data
    private var data: [ThreadViewModel] = []
    private var tableWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listener?.viewActions.on(.next(.viewWillAppear))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nc = self.navigationController as? BaseNavigationController {
            nc.interactivePopPanGestureRecognizer?.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nc = self.navigationController as? BaseNavigationController {
            nc.interactivePopPanGestureRecognizer?.isEnabled = true
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in
//            self.collectionView.layoutSubviews()
        }
    }
    


    
    // MARK: BoardPresentable

    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupCollectionView()
        self.setupNavBar()
        
        self.bgImage.alpha = 0.15
        self.bgImage.clipsToBounds = true
        
        self.setupTheme()
        
//        self.refreshControl.beginRefreshing()
    }
    
    private func setupRx() {
        self.listener?
            .mainViewModel
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
            }).disposed(by: self.disposeBag)
        
        self.listener?
            .dataSource
            .asObservable()
            .debug()
            .observeOn(Helper.rxMainThread)
            .map({ [weak self] models -> [ThreadViewModel] in
                return models.map { $0.calculateSize(max: self?.tableWidth ?? 0) }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in                
                
                if let oldData = self?.data, let collectionView = self?.collectionView {
//                    let diff = ListDiff(oldArray: oldData, newArray: result, option: .equality)
                    let diff = ListDiffPaths(fromSection: 0, toSection: 0, oldArray: oldData, newArray: result, option: .equality)
                    self?.data = result
                    
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: diff.deletes)
                        collectionView.insertItems(at: diff.inserts)
                        collectionView.reloadItems(at: diff.updates)
                        for move in diff.moves {
                            collectionView.moveItem(at: move.from, to: move.to)
                        }

                    }, completion: { finished in
                        
                    })
//                    collectionView.beginUpdates()
//                    tableView.performBatchUpdates({
//                    }, completion: { finished in
//
//                    })
                    
//                    tableView.endUpdates()
                } else {
                    self?.data = result
                    self?.collectionView.reloadData()
                }
            }).disposed(by: self.disposeBag)
        
        self.cellActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .tapped(let cell): do {
                    if let idx = self?.collectionView.indexPath(for: cell) {
                        self?.listener?.viewActions.on(.next(.openThread(idx: idx.row)))
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
                
                if IsIpad {
                    actionSheet.popoverPresentationController?.barButtonItem = self?.moreButton
                }
                
                actionSheet.addAction(UIAlertAction(title: "Скопировать ссылку на доску", style: .default, handler: { [weak self] _ in
                    self?.listener?.viewActions.on(.next(.copyLinkOnBoard))
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Открыть по ссылке", style: .default, handler: { [weak self] _ in
                    self?.listener?.viewActions.on(.next(.openByLink))
                }))
                
                
                actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                
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
        self.collectionView.register(UINib(nibName: ThreadCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ThreadCellIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableWidth = self.collectionView.frame.width
        
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.addSubview(self.refreshControl)
        }
        
//        self.tableView.backgroundColor = .snow
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: DefaultMargin, left: 0, bottom: DefaultMargin, right: 0)
    }
    
    private func setupNavBar() {
        let more = UIBarButtonItem(image: .more, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.themeManager.append(view: ThemeView(object: more, type: ThemeViewType.navBarButton, subtype: .none))
        self.moreButton = more
      
        let inset: CGFloat = 4
        let writeButton = UIButton()
        writeButton.setImage(.write, for: .normal)
        writeButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        writeButton.tintColor = self.themeManager.theme.main
        writeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.createNewThreadButton = writeButton
        let writeBarButton = UIBarButtonItem(customView: writeButton)
        
        let homeCanvas = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let homeButton = UIBarButtonItem(customView: homeCanvas)
        
        self.navigationItem.setRightBarButtonItems([more, writeBarButton], animated: false)
        self.navigationItem.setLeftBarButtonItems([homeButton], animated: false)
        
        let home = UIButton(frame: .zero)
        home.setImage(.home, for: .normal)
        home.tintColor = .main
        homeCanvas.addSubview(home)
        
        self.themeManager.append(view: ThemeView(object: home, type: .navBarButton, subtype: .none))
        
        home.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        self.homeButton = home
    }
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.collectionView, type: .collection, subtype: .none))
    }
  
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
        self.listener?.viewActions.on(.next(.openThread(idx: indexPath.row)))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreadCellIdentifier, for: indexPath)
        if let c = cell as? ThreadCell {
            c.update(with: data)
            c.actions = self.cellActions
        }
        return cell

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



