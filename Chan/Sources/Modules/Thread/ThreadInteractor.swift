//
//  ThreadInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol ThreadRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ThreadPresentable: Presentable {
    var listener: ThreadPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ThreadListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ThreadInteractor: PresentableInteractor<ThreadPresentable>, ThreadInteractable, ThreadPresentableListener {

    weak var router: ThreadRouting?
    weak var listener: ThreadListener?
    
    var service: ThreadServiceProtocol
    
    private let publish: PublishSubject<ThreadServiceProtocol.ResultType> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol) {
        self.service = service
        self.mainViewModel = Variable(ThreadViewModel(with: service.thread))
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: ThreadPresentableListener
    var mainViewModel: Variable<ThreadViewModel>
    var dataSource: Variable<[PostViewModel]> = Variable([])
    var viewActions: PublishSubject<ThreadAction> = PublishSubject()
    
    // MARK:Private
    private func setup() {
        self.setupRx()
        self.service.load()
    }
    
    private func setupRx() {
        self.service.publish = self.publish
        
        self.publish
            .subscribe(onNext: { [weak self] posts in
                guard let strongSelf = self else {
                    return
                }
                if let models = posts {
                    let result = models.compactMap { PostViewModel(model: $0, thread: strongSelf.service.thread.uid) }
                    strongSelf.dataSource.value = result
                }
            }, onError: { [weak self] error in
                
            }).disposed(by: self.disposeBag)
        
    }

}
