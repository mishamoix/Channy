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
    func openThread(with post: PostReplysViewModel)
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
    
    private var data: [PostModel] = []
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol) {
        self.service = service
        self.mainViewModel = Variable(PostMainViewModel(title: service.name))
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
    var mainViewModel: Variable<PostMainViewModel>
    var dataSource: Variable<[PostViewModel]> = Variable([])
    var viewActions: PublishSubject<PostAction> = PublishSubject()
    
    // MARK:Private
    private func setup() {
        self.setupRx()
        self.service.load()
    }
    
    private func setupRx() {
        self.service.publish = self.publish
        
        self.publish
            .subscribe(onNext: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                let models = result.result
                self?.data = models
                let manager = PostManager(posts: models, thread: strongSelf.service.thread)
                
                switch result.type {
                case .all: do {
                }
                case .replys(let parent): do {
                    manager.addFilter(by: parent.uid)
                }
                }
                
                strongSelf.dataSource.value = manager.postsVM
                    
                
            }, onError: { [weak self] error in
                
            }).disposed(by: self.disposeBag)
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let postUid): do {
                    if let post = self?.data.filter({ $0.uid == postUid }).first, let posts = self?.data, let thread = self?.service.thread {
                        let replyModel = PostReplysViewModel(parent: post, posts: posts, thread: thread)
                        self?.router?.openThread(with: replyModel)
                    }
                    }
                }
            }).disposed(by: self.disposeBag)
        
        
        
    }

}
