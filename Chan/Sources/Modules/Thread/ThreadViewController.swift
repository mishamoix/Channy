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

protocol ThreadPresentableListener: class {
    var mainViewModel: Variable<ThreadViewModel> { get }
    var dataSource: Variable<[PostViewModel]> { get }
    var viewActions: PublishSubject<ThreadAction> { get }
}

final class ThreadViewController: UIViewController, ThreadPresentable, ThreadViewControllable {
    
    // MARK: Other
    weak var listener: ThreadPresentableListener?
    private let disposeBag = DisposeBag()
    
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
    }
    
    private func setupRx() {
        self.listener?.mainViewModel
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                self?.navigationItem.title = model.title
            }).disposed(by: self.disposeBag)
    }
    
    private func setupNavBar() {
        
    }
}
