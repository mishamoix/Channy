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
    func openNewThread(with thread: ThreadModel)

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
    
    private let postsManager: PostManager
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol, cachedVM: [PostViewModel]? = nil) {
        self.service = service
        self.mainViewModel = Variable(PostMainViewModel(title: service.name))
        self.postsManager = PostManager(thread: service.thread)
        self.postsManager.update(vms: cachedVM)
        
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
                
                self?.postsManager.update(posts: models)
                self?.postsManager.process()
                
                switch result.type {
                case .all: self?.postsManager.resetFilters()
                case .replys(let parent): self?.postsManager.addFilter(by: parent.uid)
                case .replyed(let model): self?.postsManager.onlyReplyed(uid: model.uid)
                }
                
                strongSelf.dataSource.value = self?.postsManager.filtredPostsVM ?? []
                if let newName = self?.service.name {
                    self?.mainViewModel.value = PostMainViewModel(title: newName)
                }

            }, onError: { [weak self] error in
                
            }).disposed(by: self.disposeBag)
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let postUid): do {
                    if let post = self?.data.filter({ $0.uid == postUid }).first, let posts = self?.data, let thread = self?.service.thread {
                        let replyModel = PostReplysViewModel(parent: post, posts: posts, thread: thread, cachedVM: self?.postsManager.internalPostVM)
                        self?.router?.openThread(with: replyModel)
                    }
                    }
                case .openByTextIndex(let postUid, let idx): do {
                    self?.openByTextIndex(postUid: postUid, idx: idx)
                }
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func openByTextIndex(postUid: String, idx: Int) {
        let posts = self.data
        let thread = self.service.thread
        if let post = self.data.filter({ $0.uid == postUid }).first, let postVM = self.dataSource.value.first(where: { $0.uid == postUid }) {
            if let tag = postVM.tag(for: idx) {
                switch tag.type {
                case .link(let url): do {
                    let stringUrl = url.absoluteString
                    let linkParser = LinkParser(path: stringUrl)
                    
                    switch linkParser.type {
                    case .boardLink(let boardLink): do {
                        if let openThread = boardLink.thread, let boardUid = boardLink.board {
                            
                            if thread.uid != openThread {
                                // TODO: открывать новую
                                let board = BoardModel(uid: boardUid)
                                let threadToOpen = ThreadModel(uid: openThread, board: board)
                                
                                self.router?.openNewThread(with: threadToOpen)
                            } else {
                                if let replyedPost = posts.filter({ $0.uid == boardLink.post}).first {
                                    let replyes = PostReplysViewModel(parent: post, posts: posts, thread: thread, replyed: replyedPost, cachedVM: self.postsManager.internalPostVM)
                                    self.router?.openThread(with: replyes)
                                } else {
                                    self.router?.openNewThread(with: thread)

                                }
                            }
                        } else {
                            // TODO: Если ссылка вида /hw/catalog.html, '/web/'
                        }
                    }
                        
                    case .externalLink: Helper.open(url: url)
                    }
                    }
                }
            }
        }
    }

}
