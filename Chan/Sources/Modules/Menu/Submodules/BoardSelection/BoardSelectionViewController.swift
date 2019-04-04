//
//  BoardSelectionViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol BoardSelectionPresentableListener: class {
    func select(model: BoardSelectionViewModel)
    func save()
    func update(search string: String?)
    
}

final class BoardSelectionViewController: UIViewController, BoardSelectionPresentable, BoardSelectionViewControllable {

    weak var listener: BoardSelectionPresentableListener?
    
    private let disposeBag = DisposeBag()
    var data: [BoardSelectionViewModel] = []
    
    private let _uiLoaded = Variable<Bool>(false)
    var uiLoaded: Observable<Bool> {
        return self._uiLoaded.asObservable()
    }
    
    // MARK: UI
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        self._uiLoaded.value = true
    }
    
    // MARK: BoardSelectionPresentable
    
    func update(data: [BoardSelectionViewModel]) {
        self.data = data
        self.tableView.reloadData()
    }
    
    func close() {
        self.dismiss(animated: true)
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupTableView()
        self.setupHeader()
        
    }
    
    private func setupRx() {
        
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.tableView.rowHeight = 60.0
    }
    
    private func setupHeader() {
        
        self.navigationItem.title = "Добавить доску"
        
        let closeButton = UIBarButtonItem(image: UIImage.cross, landscapeImagePhone: UIImage.cross, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = closeButton
        
        closeButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.close()
            })
            .disposed(by: self.disposeBag)
        
        
        let saveButton = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = saveButton
        
        saveButton.rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.save()
            })
            .disposed(by: self.disposeBag)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Введите название или код доски"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        }
    }
}

extension BoardSelectionViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        self.listener?.update(search: searchController.searchBar.text)
    }
}

extension BoardSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.listener?.select(model: self.data[indexPath.row])
        
    }
}

extension BoardSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardSelectionCell", for: indexPath)
        
        if let cell = cell as? BoardSelectionCell {
            cell.update(with: self.data[indexPath.row])
        }
        
        return cell
    }
}
