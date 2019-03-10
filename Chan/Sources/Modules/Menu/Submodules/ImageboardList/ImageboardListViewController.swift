//
//  ImageboardListViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

let ImageboardCellIdentifier = "ImageboardCell"

protocol ImageboardListPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ImageboardListViewController: UIViewController, ImageboardListPresentable, ImageboardListViewControllable {

    weak var listener: ImageboardListPresentableListener?
    
    private var data: [ImageboardViewModel] = []
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    private let header = ImageboardHeader.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // MARK: ImageboardListPresentable
    func update(data: [ImageboardViewModel]) {
        self.data = data
        self.tableView.reloadData()
    }
    
    // MARK: Private
    private func setup() {
        self.setupUI()
    }
    
    private func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.register(UINib(nibName: ImageboardCellIdentifier, bundle: nil), forCellReuseIdentifier: ImageboardCellIdentifier)

        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableHeaderView = self.header
        
        self.header.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        self.tableView.rowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MenuIndicatorBottomOffset, right: 0)
        
    }
    
}

extension ImageboardListViewController: UITableViewDelegate {
    
}

extension ImageboardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageboardCellIdentifier, for: indexPath)
        
        if let cell = cell as? ImageboardCell {
            let model = self.data[indexPath.row]
            cell.update(with: model)
        }
        
        return cell
    }
    
    
}
