//
//  MarkedViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol MarkedPresentableListener: class {
    func open(idx: Int)
    func refresh()
    
    func viewLoaded()
    func loadNext()
    
    var hasMore: Bool { get }
}

final class MarkedViewController: BaseViewController, MarkedPresentable, MarkedViewControllable {

    weak var listener: MarkedPresentableListener?
    
    var component: MarkedComponent? = nil
    
    var models: [ThreadModel] = []
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        self.listener?.viewLoaded()
    }
    
    func update(with threads: [ThreadModel]) {
        self.models = threads
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = .clear
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        if let component = self.component {
            switch component.type {
            case .favorited:
                self.navigationItem.title = "Избранное"
            case .history:
                self.navigationItem.title = "История"
            }
        }

    }
    
    private func setupRx() {
        self.refreshControl
            .rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.listener?.refresh()
            })
            .disposed(by: self.disposeBag)

    }
}

extension MarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.listener?.open(idx: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.models.count - 1 && self.listener?.hasMore ?? true {
            self.listener?.loadNext()
        }
    }
}

extension MarkedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MarkedCell", for: indexPath)
        
        if let c = cell as? MarkedCell {
            c.update(with: self.models[indexPath.row])
        }
        
//        cell.textLabel?.text = self.models[indexPath.row].subject
        
        return cell
    }
    
    
    
}
