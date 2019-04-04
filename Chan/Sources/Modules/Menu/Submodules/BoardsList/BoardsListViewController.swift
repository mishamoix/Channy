//
//  BoardsListViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SwiftReorder
import IGListKit
import ReCaptcha


let BoardsListCellIdentifier = "BoardsListCell"
let BoardsTableHeaderIdentifier = "BoardsTableHeader"

protocol BoardsListPresentableListener: class {
    var dataSource: Variable<ImageboardModel?> { get }
    var viewActions: PublishSubject<BoardsListAction> { get }

}

final class BoardsListViewController: BaseViewController, BoardsListPresentable, BoardsListViewControllable, ViewRefreshing {
    weak var listener: BoardsListPresentableListener?
    
    // MARK: Data
    private var imageboard: ImageboardModel? = nil
    private var boards: [BoardModel] = []
    
    //MARK: UI
    @IBOutlet weak var tableView: UITableView!
    private let seacrhBar: UISearchBar = UISearchBar()
    
    private weak var settingButton: UIButton?
    private weak var plusButton: UIButton?
    private weak var closeButton: UIButton?
    
    private let header = BoardsTableHeader.instance
    
    var re: ReCaptcha? = nil
  
  //MARK: Other
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private var canAction: Bool {
        return (self.seacrhBar.text?.count ?? 0) == 0 ? true : false
    }
    

    
    // MARK: BoardsListPresentable
    
    // MARK: ViewRefreshing
    func endRefresh() {
    }
    func startRefresh() {
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
//        self.view.backgroundColor = UIColor.
        self.setupTableView()
        self.setupSearchBar()
        
        self.navigationItem.title = "Список досок"
        
        self.setupTheme()
        
      
      
//        let recaptcha = try? ReCaptcha(apiKey: "6LdwXD4UAAAAAHxyTiwSMuge1-pf1ZiEL4qva_xu", baseURL: URL(string: "https://2ch.hk"))
//        
//        
//        recaptcha?.configureWebView({ [weak self] webView in
//            webView.frame = self?.view.bounds ?? CGRect.zero
//        })
//        
//        self.re = recaptcha
//        
////        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//        
//        recaptcha?.validate(on: self.tableView, completion: { result in
//            print(result)
//            self.re?.reset()
//        })
        
//            recaptcha?
//                .rx
//                .validate(on: self.tableView).asObservable().subscribe(onNext: { result in
//                    print(result)
//                }, onError: { error in
//                    print(error)
//                }).disposed(by: self.disposeBag)
//        }
        
    }
    
    private func setupRx() {
        self.listener?
            .dataSource
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] result in
                self?.imageboard = result
                self?.updateViews()
            })
            .disposed(by: self.disposeBag)
        
        if let listener = self.listener {
            self.header
                .addBoards
                .rx
                .tap
                .asObservable()
                .map { return BoardsListAction.openBoardsSelection }
                .bind(to: listener.viewActions)
                .disposed(by: self.disposeBag)
        }
        
//        self.settingButton?
//            .rx
//            .tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] in
//                self?.listener?.viewActions.on(.next(.openSettings))
//            })
//            .disposed(by: self.disposeBag)
//
//        self.plusButton?
//            .rx
//            .tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] in
//                self?.listener?.viewActions.on(.next(.addNewBoard))
//            })
//            .disposed(by: self.disposeBag)
//
//        self.closeButton?
//            .rx
//            .tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] in
////                self?.navigationController?.dismiss(animated: true, completion: nil)
//                self?.listener?.viewActions.on(.next(.close))
//            })
//            .disposed(by: self.disposeBag)
        
        
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: BoardsListCellIdentifier, bundle: nil), forCellReuseIdentifier: BoardsListCellIdentifier)
        self.tableView.register(UINib(nibName: BoardsTableHeaderIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: BoardsTableHeaderIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.reorder.delegate = self
        self.tableView.reorder.isEnabled = false
        
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableHeaderView = self.header
        
        self.header.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        
        if #available(iOS 11.0, *) {} else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
    }
    
    private func setupSearchBar() {
//        self.seacrhBar.searchBarStyle = .prominent
//        self.seacrhBar.placeholder = "Фильтр по доскам"
//        self.navigationItem.titleView = self.seacrhBar
//        self.seacrhBar.delegate = self
//
        let settings = UIButton(frame: .zero)
        settings.setImage(.settings, for: .normal)
        settings.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        settings.tintColor = .main

        let plus = UIButton(frame: .zero)
        plus.setImage(.plus, for: .normal)
        plus.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        plus.tintColor = .main
        
        self.themeManager.append(view: ThemeView(object: settings, type: .navBarButton, subtype: .none))
        self.themeManager.append(view: ThemeView(object: plus, type: .navBarButton, subtype: .none))

        let settingButton = UIBarButtonItem(customView: settings)
        let plusButton = UIBarButtonItem(customView: plus)
        
        self.settingButton = settings
        self.plusButton = plus
        
        self.navigationItem.setRightBarButtonItems([settingButton, plusButton], animated: false)
//        self.navigationItem.rightBarButtonItem = settingButton
        
        let closeCanvas = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let closeButton = UIBarButtonItem(customView: closeCanvas)
        self.navigationItem.leftBarButtonItem = closeButton

        
        let close = UIButton(frame: .zero)
        closeCanvas.addSubview(close)
        close.setImage(.cross, for: .normal)
        close.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        close.tintColor = .main
        self.closeButton = close
        
        self.themeManager.append(view: ThemeView(object: close, type: .navBarButton, subtype: .none))


    }
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.tableView, type: .table, subtype: .none))
//        ThemeManager.shared.append(view: ThemeView(object: self.navigationController?.navigationBar, type: .navBar, subtype: .none))
    }
    
    private func updateViews() {
        if let data = self.imageboard {
            self.header.update(with: data)
            self.boards = data.boards.filter({ $0.selected })
            self.tableView.reloadData()
        }
    }
}

extension BoardsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.listener?.viewActions.on(.next(.openBoard(index: indexPath)))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BoardsListCellHeight
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let board = self.boards[indexPath.row]
//            self.listener?.viewActions.on(.next(.delete(uid: board.uid)))
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.canAction {
            return [UITableViewRowAction(style: .destructive, title: "Удалить", handler: { [weak self] (action, idexPath) in
                
                if let board = self?.boards[indexPath.row] {
//                    self?.listener?.viewActions.on(.next(.delete(uid: board.uid)))
                }

                
            })]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

extension BoardsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BoardsListCellIdentifier, for: indexPath) as! BoardsListCell
        let data = self.boards[indexPath.row]
        cell.update(with: data)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boards.count
    }

}

extension BoardsListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reorder.isEnabled = self.canAction
//        self.listener?.viewActions.on(.next(.seacrh(text: searchText)))
    }
}

extension BoardsListViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }
    
    func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
//        print("From \(sourceIndexPath), to: \(destinationIndexPath)")
//        self.listener?.viewActions.on(.next(.move(from: initialSourceIndexPath, to: finalDestinationIndexPath)))

    }

}


