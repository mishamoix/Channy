//
//  BoardInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol BoardRouting: ViewableRouting {
    func open(thread: ThreadModel)
}

protocol BoardPresentable: Presentable {
    var listener: BoardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BoardListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BoardInteractor: PresentableInteractor<BoardPresentable>, BoardInteractable, BoardPresentableListener {

    weak var router: BoardRouting?
    weak var listener: BoardListener?
    
    private var service: BoardServiceProtocol
    private let serviceListener: PublishSubject<BoardServiceProtocol.ResultType> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private var data: [ThreadModel] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardPresentable, service: BoardServiceProtocol) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
        
        self.mainViewModel.value = BoardMainViewModel(title: self.service.board.name)
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
        
        self.service.loadNext()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: BoardPresentableListener
    var mainViewModel: Variable<BoardMainViewModel> = Variable(BoardMainViewModel(title: ""))
    var dataSource: Variable<[ThreadViewModel]> = Variable([])
    
    var viewActions: PublishSubject<BoardAction> = PublishSubject()

    // MARK: ThreadListener
    func popToRoot() {
        // pop to root thread
    }
    
    // MARK: Private
    func setup() {
        self.service.publish = self.serviceListener
        self.setupRx()
    }
    
    func setupRx() {
        self.serviceListener
            .subscribe(onNext: { [weak self] result in
//                if let result = result {
                let threads = result.result
                let threadsVM = threads.map({ ThreadViewModel(with: $0) })
                
                switch result.type {
                case .first:
                    self?.data = threads
                    self?.dataSource.value = threadsVM
                default:
                    self?.data += threads
                    self?.dataSource.value += threadsVM
                }
                
                
//                }
            }, onError: { error in
                
            }).disposed(by: self.disposeBag)
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .loadNext: do {
                    self?.service.loadNext()
                }
                case .openThread(let idx): do {
                    if let thread = self?.data[idx] {
                        self?.router?.open(thread: thread)
                    }
                }
                case .reload: do {
                    self?.service.cancel()
                    self?.service.reload()
                    }
                }
            }).disposed(by: self.disposeBag)
    }

}
