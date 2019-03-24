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
    func popToCurrent(animated: Bool)
    func showMediaViewer(_ vc: UIViewController)
    func closeThread()
    func showWrite(model: ThreadModel, data: Observable<String>)
    func closeWrite()
}

protocol ThreadPresentable: Presentable {
    var listener: ThreadPresentableListener? { get set }
//    func needAutoscroll(to uid: String)
    var autosctollUid: String? { get set }
    func scrollToLast()

}

protocol ThreadListener: class {
    func popToRoot(animated: Bool)
    func open(board: BoardModel)
    func reply(postUid: String)
    
}

final class ThreadInteractor: PresentableInteractor<ThreadPresentable>, ThreadInteractable, ThreadPresentableListener {

    

    weak var router: ThreadRouting?
    weak var listener: ThreadListener?
    private var viewer: ThreadImageViewer? = nil
    
    var service: ThreadServiceProtocol
    
    private let disposeBag = DisposeBag()
    
    private var data: [PostModel] = []
//    private var viewModels: [PostViewModel] = []
    
    private var postsManager: PostManager? = nil
    internal let moduleIsRoot: Bool
    
    private let replySubject = BehaviorSubject<String>(value: "")
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol, moduleIsRoot: Bool, cachedVM: [PostViewModel]? = nil) {
        self.service = service
        self.moduleIsRoot = moduleIsRoot
        self.mainViewModel = Variable(PostMainViewModel(title: service.name, canRefresh: self.moduleIsRoot))
        self.postsManager = PostManager(thread: service.thread)
        self.postsManager?.update(vms: cachedVM)
        
        super.init(presenter: presenter)
        presenter.listener = self
        
        if let post = self.service.thread.currentPost, self.moduleIsRoot {
            self.presenter.autosctollUid = post
        }
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
    }

    override func willResignActive() {
        super.willResignActive()
        
        self.service.cancel()
        self.postsManager?.cancel()
        self.postsManager = nil
        self.viewer = nil
    }
    
    // MARK: ThreadPresentableListener
    var mainViewModel: Variable<PostMainViewModel>
    var dataSource: Variable<[PostViewModel]> = Variable([])
    var viewActions: PublishSubject<PostAction> = PublishSubject()
    
    // MARK: ThreadListener
    func popToRoot(animated: Bool = true) {
        if self.moduleIsRoot {
            self.router?.popToCurrent(animated: animated)
        } else {
            self.listener?.popToRoot(animated: animated)
        }
    }
    
    // MARK: WriteListener
    func messageWrote(model: WriteResponseModel) {
        switch model {
        case .postCreated(let post):
            self.presenter.autosctollUid = post
        default: break
            
        }
        self.replySubject.on(.next(""))
        self.postsManager?.resetCache()
        self.load()
        self.router?.closeWrite()
    }
    
    // MARK:Private
    private func setup() {
        self.setupRx()
        
        if self.moduleIsRoot {
            self.presenter.showCentralActivity()
        }
        self.load()
    }
    
    private func setupRx() {
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openReplys(let postUid): do {
                    if let post = self?.data.filter({ $0.uid == postUid }).first, let posts = self?.data, let thread = self?.service.thread {
                        let replyModel = PostReplysViewModel(parent: post, posts: posts, thread: thread, cachedVM: self?.postsManager?.internalPostVM)
                        self?.router?.openThread(with: replyModel)
                    }
                }
                case .reply(let postUid): self?.reply(postUid: postUid)
                case .refresh: do {
                    if self?.moduleIsRoot ?? false {
                        self?.postsManager?.resetCache()
                        self?.load()
                    }
                }
                    
                case .openLink(let postUid, let url): self?.openByTextIndex(postUid: postUid, url: url)
                case .popToRoot: self?.popToRoot()
                case .reportThread: self?.reportThread()
                case .copyPost(let postUid): self?.copyPost(uid: postUid)
                case .cutPost(let postUid): self?.cutPost(uid: postUid)
                case .open(let media): self?.showMedia(with: media)
                case .copyLinkOnThread: self?.copyLinkOnThread()
                case .copyMedia(let media): self?.copyMedia(media: media)
                case .copyLinkPost(let postUid): self?.copyLinkPost(uid: postUid)
                case .replyThread: self?.openWrite()
                case .openMediaBrowser(let model): self?.openMediaInBrowser(model)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func load() {
        
        self.service
            .load()
            .asObservable()
            .debug()
            .observeOn(Helper.rxBackgroundThread)
            .retryWhen({ [weak self] (errorObservable) -> Observable<Void> in
                return errorObservable.flatMap({ [weak self] error -> Observable<Void> in
                    let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])
                    Helper.performOnMainThread {
                        self?.presenter.stopAnyLoaders()
                        errorManager.show()
                    }

                    return errorManager.actions
                        .flatMap({ [weak self] type -> Observable<()> in
                            if type == .retry {
                                self?.presenter.showCentralActivity()

                                return Observable<Void>.just(Void())
                            } else {
                                self?.presenter.stopAnyLoaders()
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
                case .all:
                    strongSelf.postsManager?.resetFilters()
                    let files = models.flatMap { $0.files }
                    CensorManager.censor(files: files)
                case .replys(let parent): strongSelf.postsManager?.addFilter(by: parent.uid)
                case .replyed(let model): strongSelf.postsManager?.onlyReplyed(uid: model.uid)
                }
                self?.postsManager?.update(posts: models)

                self?.mainViewModel.value = PostMainViewModel(title: strongSelf.service.name, canRefresh: strongSelf.moduleIsRoot)

                return Observable<[PostModel]>.just(models)
            })
            .map({ [weak self] models -> [PostViewModel] in
                print("start mapping")
                let start = Date()
                self?.postsManager?.process()
                let end = Date()
                print("end mapping \(end.timeIntervalSince1970 - start.timeIntervalSince1970)")
                return self?.postsManager?.filtredPostsVM ?? []
            })
            .flatMap({ [weak self] models -> Observable<[PostViewModel]> in
                self?.presenter.stopAnyLoaders()
                return Observable<[PostViewModel]>.just(self?.postsManager?.filtredPostsVM ?? [])
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
//                        let board = BoardModel(uid: boardUid)
//                        let threadToOpen = ThreadModel(uid: openThread, board: board)
//
//                        self.router?.openNewThread(with: threadToOpen)
                    } else {
                        if let replyedPost = posts.filter({ $0.uid == boardLink.post}).first {
                            let replyes = PostReplysViewModel(parent: post, posts: posts, thread: thread, replyed: replyedPost, cachedVM: self.postsManager?.internalPostVM)
                            self.router?.openThread(with: replyes)
                        } else {
                            self.router?.openNewThread(with: thread)

                        }
                    }
                } else if let boardUid = boardLink.board {
//                    let board = BoardModel(uid: boardUid)
//                    self.open(board: board)
                    // TODO: Если ссылка вида /hw/catalog.html, '/web/'
                }
            }
                
            case .externalLink: Helper.open(url: url)
            }
        }
    }
    
    func open(board: BoardModel) {
        self.router?.closeThread()
        self.listener?.open(board: board)
    }
    
    func reply(postUid: String) {
        if self.moduleIsRoot {
            self.popToRoot(animated: true)
            self.openWrite()
            
            let replyText = ">>\(postUid)"
            self.replySubject.on(.next(replyText))

        } else {
            self.listener?.reply(postUid: postUid)
        }

    }
    
    private func openWrite() {
        self.router?.showWrite(model: self.service.thread, data: self.replySubject.asObservable())
    }
    
    private func reportThread() {
        FirebaseManager.shared.report(thread: self.service.thread)
    }
    
    private func copyPost(uid: String) {
        if let post = self.data.first(where: { $0.uid == uid }) {
            UIPasteboard.general.string = post.comment
        }
    }
    
    private func cutPost(uid: String) {
        if let post = self.postsManager?.filtredPostsVM.first(where: { $0.uid == uid }) {
            UIPasteboard.general.string = post.text.string
        }
    }
    
    private func copyMedia(media: FileModel) {
        let url = MakeFullPath(path: media.path)
        UIPasteboard.general.string = url
        ErrorDisplay.presentAlert(with: "Ссылка скопирована!", message: url, dismiss: SmallDismissTime)
    }
    
    private func copyLinkPost(uid: String) {
        if let link = self.service.thread.buildLink {
            
            UIPasteboard.general.string = link + "#\(uid)"
//            ErrorDisplay.presentAlert(with: "Ссылка скопирована!", message: link, dismiss: SmallDismissTime)
            
        } else {
//            ErrorDisplay.presentAlert(with: nil, message: "Ошибка копирования ссылки", dismiss: SmallDismissTime)
        }

    }

    
    private func showMedia(with anchor: FileModel) {
      
      #if RELEASE
      
      if anchor.type == .image {
        let allFiles = self.data.flatMap { $0.files }.filter({ $0.type == .image })
        let viewer = ThreadImageViewer(files: allFiles, anchor: anchor)
        if let vc = viewer.browser {
          self.router?.showMediaViewer(vc)
        }
        
        self.viewer = viewer
      } else {
        print(anchor.path)
        
        
        if VLCOpener.hasVLC() {
            VLCOpener.openInVLC(url: anchor.path)
        } else {
            let error = ChanError.error(title: "Открытие видео", description: "Для просмотра видео рекомендуем установить VLC плеер.")
            
            let display = ErrorDisplay(error: error, buttons: [.cancel, .custom(title: "Открыть в браузере", style: UIAlertAction.Style.default), .custom(title: "VLC в App Store", style: UIAlertAction.Style.default)])
            
            display
                .actions
                .subscribe(onNext: { [weak self, weak anchor] action in
                    switch action {
                    case .custom(let title, _):
                        if title.lowercased() == "vlc в app store" {
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id650377962"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.openURL(url)
                            }
                        } else {
                            if let model = anchor {
                                self?.openMediaInBrowser(model)
                            }
                        }
                    default: break
                    }
                })
                .disposed(by: self.disposeBag)
            
            display.show()


        }
        
//        if anchor.path.hasSuffix(".webm") { //}|| anchor.path.hasSuffix(".ogg") {
//          let webm = WebmPlayerViewController(with: anchor)
//          self.router?.showMediaViewer(webm)
//        } else {
//          let player = VideoPlayer(with: anchor)
//          if let pl = player.videoPlayer {
//            self.router?.showMediaViewer(pl)
//          }
//        }
      }


//            if CensorManager.isCensored(model: anchor) {
//                let error = ChanError.error(title: "Внимание", description: "Медиа содержит неприемлимый контент. ")
//                //
//                let display = ErrorDisplay(error: error, buttons: [.cancel, .custom(title: "Открыть", style: UIAlertAction.Style.default)])
//
//                display.show()
//                display
//                    .actions
//                    .subscribe(onNext: { [weak self, weak anchor] action in
//                        switch action {
//                        case .custom(_, _):
//                            if let model = anchor {
//                                self?.openMediaInBrowser(model)
//                            }
//                        default: break
//                        }
//                    })
//                    .disposed(by: self.disposeBag)
//            } else {
//
//                self.openMediaInBrowser(anchor)
//            }
      #else
        if anchor.type == .image {
            let allFiles = self.data.flatMap { $0.files }.filter({ $0.type == .image })
            let viewer = ThreadImageViewer(files: allFiles, anchor: anchor)
            if let vc = viewer.browser {
                self.router?.showMediaViewer(vc)
            }
        } else {
            print(anchor.path)
            if anchor.path.hasSuffix(".webm") { //}|| anchor.path.hasSuffix(".ogg") {
                let webm = WebmPlayerViewController(with: anchor)
                self.router?.showMediaViewer(webm)
            } else {
                let player = VideoPlayer(with: anchor)
                if let pl = player.videoPlayer {
                    self.router?.showMediaViewer(pl)
                }
            }
        }

      #endif

        
//        if !LinkOpener.shared.browserIsSelected {
//            LinkOpener
//                .shared
//                .selectDefaultBrowser()
//                .subscribe { _ in
//                    block()
//                }
//                .disposed(by: self.disposeBag)
//        } else {
//            block()
//        }
        
    }
    
    
    private func copyLinkOnThread() {
        if let link = self.service.thread.buildLink {
            UIPasteboard.general.string = link
            ErrorDisplay.presentAlert(with: "Ссылка скопирована!", message: link, dismiss: SmallDismissTime)

        } else {
            ErrorDisplay.presentAlert(with: nil, message: "Ошибка копирования ссылки", dismiss: SmallDismissTime)
        }
    }
    
    private func openMediaInBrowser(_ media: FileModel) {
//        LinkOpener.shared.open(url: media.url)
        Helper.open(url: media.url)
        
    }

}
