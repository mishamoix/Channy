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
    func popToCurrent()
}

protocol ThreadPresentable: Presentable {
    var listener: ThreadPresentableListener? { get set }
}

protocol ThreadListener: class {
    func popToRoot()
}

final class ThreadInteractor: PresentableInteractor<ThreadPresentable>, ThreadInteractable, ThreadPresentableListener {

    weak var router: ThreadRouting?
    weak var listener: ThreadListener?
    
    var service: ThreadServiceProtocol
    
//    private let publish: PublishSubject<ThreadServiceProtocol.ResultType> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private var data: [PostModel] = []
    
    private let postsManager: PostManager
    private let moduleIsRoot: Bool
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol, moduleIsRoot: Bool, cachedVM: [PostViewModel]? = nil) {
        self.service = service
        self.moduleIsRoot = moduleIsRoot
        self.mainViewModel = Variable(PostMainViewModel(title: service.name, canRefresh: self.moduleIsRoot))
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
        
        self.service.cancel()
        self.postsManager.cancel()
    }
    
    // MARK: ThreadPresentableListener
    var mainViewModel: Variable<PostMainViewModel>
    var dataSource: Variable<[PostViewModel]> = Variable([])
    var viewActions: PublishSubject<PostAction> = PublishSubject()
    
    // MARK: ThreadListener
    func popToRoot() {
        if self.moduleIsRoot {
            self.router?.popToCurrent()
        } else {
            self.listener?.popToRoot()
        }
    }
    
    // MARK:Private
    private func setup() {
        self.setupRx()
        self.load()
    }
    
    private func setupRx() {
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let postUid): do {
                    if let post = self?.data.filter({ $0.uid == postUid }).first, let posts = self?.data, let thread = self?.service.thread {
                        let replyModel = PostReplysViewModel(parent: post, posts: posts, thread: thread, cachedVM: self?.postsManager.internalPostVM)
                        self?.router?.openThread(with: replyModel)
                    }
                    }
                case .openLink(let postUid, let url): do {
                    self?.openByTextIndex(postUid: postUid, url: url)
                }
                case .refresh: do {
                    if self?.moduleIsRoot ?? false {
                        self?.postsManager.resetCache()
                        self?.load()
                    }
                }
                case .popToRoot: do {
                    self?.popToRoot()
                }
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func load() {
        self.presenter.startRefreshing()
        
        self.service
            .load()
            .asObservable()
            .debug()
            .observeOn(Helper.rxBackgroundThread)
            .retryWhen({ [weak self] (errorObservable) -> Observable<Void> in
                return errorObservable.flatMap({ [weak self] error -> Observable<Void> in
                    let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])
                    errorManager.show()

                    return errorManager.actions
                        .flatMap({ [weak self] type -> Observable<()> in
                            if type == .retry {
                                self?.presenter.startRefreshing()

                                return Observable<Void>.just(Void())
                            } else {
                                self?.presenter.endRefreshing()
                                return Observable<Void>.empty()
                            }
                        })
                })
            })
            .flatMap({ [weak self] (result) -> Observable<[PostModel]> in
                guard let strongSelf = self else {
                    return Observable.empty()
                }
                let models = result.result
                strongSelf.data = models


                switch result.type {
                case .all: strongSelf.postsManager.resetFilters()
                case .replys(let parent): strongSelf.postsManager.addFilter(by: parent.uid)
                case .replyed(let model): strongSelf.postsManager.onlyReplyed(uid: model.uid)
                }
                self?.postsManager.update(posts: models)

                self?.mainViewModel.value = PostMainViewModel(title: strongSelf.service.name, canRefresh: strongSelf.moduleIsRoot)

                return Observable<[PostModel]>.just(models)
            })
            .map({ [weak self] models -> [PostViewModel] in
                print("start mapping")
                let start = Date()
                self?.postsManager.process()
                let end = Date()
                print("end mapping \(end.timeIntervalSince1970 - start.timeIntervalSince1970)")
                return self?.postsManager.filtredPostsVM ?? []
            })
            .flatMap({ [weak self] models -> Observable<[PostViewModel]> in
                self?.presenter.endRefreshing()
                return Observable<[PostViewModel]>.just(self?.postsManager.filtredPostsVM ?? [])
            })
            .bind(to: self.dataSource)
            .disposed(by: self.service.disposeBag)
    }
    
    private func openByTextIndex(postUid: String, url: URL) {
        let posts = self.data
        let thread = self.service.thread
        
        if let post = self.data.first(where: { $0.uid == postUid }) {
            let stringUrl = url.absoluteString
            let linkParser = LinkParser(path: stringUrl)
            
            switch linkParser.type {
            case .boardLink(let boardLink): do {
                if let openThread = boardLink.thread, let boardUid = boardLink.board {
                    
                    if thread.uid != openThread {
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
