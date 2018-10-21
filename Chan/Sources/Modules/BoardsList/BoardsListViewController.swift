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

let BoardsListCellIdentifier = "BoardsListCell"
let BoardsTableHeaderIdentifier = "BoardsTableHeader"

protocol BoardsListPresentableListener: class {
    var dataSource: Variable<[BoardCategoryModel]> { get }
    var viewActions: PublishSubject<BoardsListAction> { get }
}

final class BoardsListViewController: BaseViewController, BoardsListPresentable, BoardsListViewControllable, ViewRefreshing {
    weak var listener: BoardsListPresentableListener?
    
    // MARK: Data
    private var category: [BoardCategoryModel] {
        return self.listener?.dataSource.value ?? []
    }
    
    //MARK: UI
    @IBOutlet weak var tableView: UITableView!
    private let seacrhBar: UISearchBar = UISearchBar()
  
  //MARK: Other
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
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
        
        self.navigationItem.title = "Главная"
        
    }
    
    private func setupRx() {
        self.listener?.dataSource
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] result in
                self?.tableView.reloadData()
            }).disposed(by: self.disposeBag)
        
        self.navigationItem.rightBarButtonItem?
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.listener?.viewActions.on(.next(.openSettings))
            }).disposed(by: self.disposeBag)
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: BoardsListCellIdentifier, bundle: nil), forCellReuseIdentifier: BoardsListCellIdentifier)
        self.tableView.register(UINib(nibName: BoardsTableHeaderIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: BoardsTableHeaderIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.keyboardDismissMode = .interactive

    }
    
    private func setupSearchBar() {
        self.seacrhBar.searchBarStyle = .prominent
        self.seacrhBar.placeholder = "Фильтр по доскам"
        self.navigationItem.titleView = self.seacrhBar
        self.seacrhBar.delegate = self
        
        let settingButton = UIBarButtonItem(image: .settings, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = settingButton
    }
}

extension BoardsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.listener?.viewActions.on(.next(.openBoard(index: indexPath)))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BoardsListCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BoardsTableHeaderHeight
    }
}

extension BoardsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoardsListCellIdentifier, for: indexPath) as! BoardsListCell
        let data = self.category[indexPath.section].boards[indexPath.row]
        cell.update(with: data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category[section].boards.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BoardsTableHeaderIdentifier) as! BoardsTableHeader
        header.update(with: self.category[section])
        return header
        
    }
}

extension BoardsListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.listener?.viewActions.on(.next(.seacrh(text: searchText)))
    }
}
