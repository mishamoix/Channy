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
    var vc: UIViewController { get }
}

protocol ThreadListener: class {
    func popToRoot(animated: Bool)
    func open(board: BoardModel)
    func reply(postUid: Int)
    
}

final class ThreadInteractor: PresentableInteractor<ThreadPresentable>, ThreadInteractable, ThreadPresentableListener {

    weak var router: ThreadRouting?
    weak var listener: ThreadListener?
    private var viewer: ThreadImageViewer? = nil
    
    let service: ThreadServiceProtocol
    let historyService: WriteMarkServiceProtocol?
    let favoriteService: WriteMarkServiceProtocol?
    
    private let disposeBag = DisposeBag()
    
    private var data: [PostModel] = []
    private var thread: ThreadModel? = nil
    
    private var postsManager: PostManager? = nil
    internal let moduleIsRoot: Bool
    
    private let replySubject = BehaviorSubject<String>(value: "")
    
    init(presenter: ThreadPresentable, service: ThreadServiceProtocol, moduleIsRoot: Bool, thread: ThreadModel?, history: WriteMarkServiceProtocol? = nil, favorite: WriteMarkServiceProtocol? = nil) {
        self.service = service
        self.moduleIsRoot = moduleIsRoot
        self.thread = thread
        self.historyService = history
        self.favoriteService = favorite
        self.mainViewModel = Variable(ThreadMainViewModel(thread: thread, canRefresh: self.moduleIsRoot))
//        self.postsManager = PostManager(thread: service.thread)
//        self.postsManager?.update(vms: cachedVM)
        
        super.init(presenter: presenter)
        presenter.listener = self
        
//        if let post = self.service.thread.currentPost, self.moduleIsRoot {
//            self.presenter.autosctollUid = post
//        }
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
        
        if let thread = self.thread {
            self.historyService?.write(thread: thread)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        
        self.service.cancel()
//        self.postsManager?.cancel()
        self.postsManager = nil
        self.viewer = nil
    }
    
    // MARK: ThreadPresentableListener
    var mainViewModel: Variable<ThreadMainViewModel>
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
            self.presenter.autosctollUid = post ?? "last"
        default: break
            
        }
        self.replySubject.on(.next(""))
//        self.postsManager?.resetCache()
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
                    if let post = self?.data.filter({ $0.uid == postUid }).first, let thread = self?.thread {
                        let model = PostReplysViewModel(parent: post, thread: thread)
                        self?.router?.openThread(with: model)
                    }
                }
                case .openPostReply(let postUid): do {
                    if let post = self?.thread?.posts.filter({ $0.uid == postUid }).first, let thread = self?.thread {
                        let model = PostReplysViewModel(parent: post, thread: thread, type: .reply)
                        self?.router?.openThread(with: model)
                    }

                }
                case .reply(let postUid): self?.reply(postUid: postUid)
                case .refresh: do {
                    if self?.moduleIsRoot ?? false {
                        self?.load()
//                        self?.postsManager?.resetCache()
//                        self?.load()
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
                case .changeFavorite: self?.changeFavorite()
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
            .flatMap({ [weak self] (result) -> Observable<ThreadModel> in
                guard let self = self else {
                    return Observable.empty()
                }
                
                let thread = result.result
                
                if self.moduleIsRoot {
                    self.thread = thread
                }
                self.data = thread.posts

                self.updateMainModel()
//                self.mainViewModel.value = ThreadMainViewModel(thread: thread, canRefresh: self.moduleIsRoot)

                return Observable<ThreadModel>.just(thread)
            })
            .map({ [weak self] model -> [PostViewModel] in
                
                let postManager = PostManager(thread: model)
                postManager.process()
//                self.view
                return postManager.cachedViewModels
//                return self?.postsManager?.filtredPostsVM ?? []
            })
            .flatMap({ [weak self] models -> Observable<[PostViewModel]> in
                self?.presenter.stopAnyLoaders()
                
                let result = AdsThreadManager(posts: models).prepareAds()
                
                return Observable<[PostViewModel]>.just(result)
            })
            .bind(to: self.dataSource)
            .disposed(by: self.service.disposeBag)
    }
    
    private func updateMainModel() {
        self.mainViewModel.value = ThreadMainViewModel(thread: self.thread, canRefresh: self.moduleIsRoot)
    }
    
    private func openByTextIndex(postUid: Int, url: URL) {
        
        Helper.open(url: url)
        
//        let posts = self.data
//        let thread = self.thread
        
//        guard let
//        let thread = self.service.thread
        
//        if let post = self.data.first(where: { $0.uid == postUid }) {
//            let stringUrl = url.absoluteString
//            let linkParser = LinkParser(path: stringUrl)
//
//            switch linkParser.type {
//            case .boardLink(let boardLink): do {
//                if let openThread = boardLink.thread, let boardUid = boardLink.board {
//
//                    if thread.uid != openThread {
////                        let board = BoardModel(uid: boardUid)
////                        let threadToOpen = ThreadModel(uid: openThread, board: board)
////
////                        self.router?.openNewThread(with: threadToOpen)
//                    } else {
//                        if let replyedPost = posts.filter({ $0.uid == boardLink.post}).first {
//                            let replyes = PostReplysViewModel(parent: post, posts: posts, thread: thread, replyed: replyedPost, cachedVM: self.postsManager?.internalPostVM)
//                            self.router?.openThread(with: replyes)
//                        } else {
//                            self.router?.openNewThread(with: thread)
//
//                        }
//                    }
//                } else if let boardUid = boardLink.board {
////                    let board = BoardModel(uid: boardUid)
////                    self.open(board: board)
//                    // TODO: Если ссылка вида /hw/catalog.html, '/web/'
//                }
//            }
//
//            case .externalLink: Helper.open(url: url)
//            }
//        }
    }
    
    func open(board: BoardModel) {
        self.router?.closeThread()
        self.listener?.open(board: board)
    }
    
    func reply(postUid: Int) {
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
        if let thread = self.thread {
            self.router?.showWrite(model: thread, data: self.replySubject.asObservable())
        }
    }
    
    private func reportThread() {
//        FirebaseManager.shared.report(thread: self.service.thread)
    }
    
    private func copyPost(uid: Int) {
        if let post = self.data.first(where: { $0.uid == uid }) {
            UIPasteboard.general.string = post.comment
        }
    }
    
    private func cutPost(uid: Int) {
//        if let post = self.postsManager?.filtredPostsVM.first(where: { $0.uid == uid }) {
//            UIPasteboard.general.string = post.text.string
//        }
    }
    
    private func copyMedia(media: MediaModel) {
        if let result = media.url?.absoluteString {
            UIPasteboard.general.string = result
            ErrorDisplay.presentAlert(with: "link_copied".localized, message: result, dismiss: SmallDismissTime)
        }
    }
    
    private func copyLinkPost(uid: Int) {
    }

    
    private func showMedia(with anchor: MediaModel) {


        if anchor.type == .image {
            let allFiles = self.data.flatMap { $0.files }.filter({ $0.type == .image })
            let viewer = ThreadImageViewer(files: allFiles, anchor: anchor)
            if let vc = viewer.browser {
              self.router?.showMediaViewer(vc)
            }

            self.viewer = viewer
        } else {
            if let url = anchor.url?.absoluteString {
                if CensorManager.isCensored(model: anchor) {
                    self.openVideoExternal(url: url)
                } else {
                    let videoPlayer = VideoPlayer(with: anchor)
                    videoPlayer.play(vc: self.presenter.vc)
                }
        }
    }


//      #if RELEASE
//
//      if anchor.type == .image {
//        let allFiles = self.data.flatMap { $0.files }.filter({ $0.type == .image })
//        let viewer = ThreadImageViewer(files: allFiles, anchor: anchor)
//        if let vc = viewer.browser {
//          self.router?.showMediaViewer(vc)
//        }
//
//        self.viewer = viewer
//      } else {
//        print(anchor.path)
//
//
//        if VLCOpener.hasVLC() {
//            VLCOpener.openInVLC(url: anchor.path)
//        } else {
//            let error = ChanError.error(title: "Открытие видео", description: "Для просмотра видео рекомендуем установить VLC плеер.")
//
//            let display = ErrorDisplay(error: error, buttons: [.cancel, .custom(title: "Открыть в браузере", style: UIAlertAction.Style.default), .custom(title: "VLC в App Store", style: UIAlertAction.Style.default)])
//
//            display
//                .actions
//                .subscribe(onNext: { [weak self, weak anchor] action in
//                    switch action {
//                    case .custom(let title, _):
//                        if title.lowercased() == "vlc в app store" {
//                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id650377962"), UIApplication.shared.canOpenURL(url) {
//                                UIApplication.shared.openURL(url)
//                            }
//                        } else {
//                            if let model = anchor {
//                                self?.openMediaInBrowser(model)
//                            }
//                        }
//                    default: break
//                    }
//                })
//                .disposed(by: self.disposeBag)
//
//            display.show()
//
//
//        }
//
////        if anchor.path.hasSuffix(".webm") { //}|| anchor.path.hasSuffix(".ogg") {
////          let webm = WebmPlayerViewController(with: anchor)
////          self.router?.showMediaViewer(webm)
////        } else {
////          let player = VideoPlayer(with: anchor)
////          if let pl = player.videoPlayer {
////            self.router?.showMediaViewer(pl)
////          }
////        }
//      }
//
//
////            if CensorManager.isCensored(model: anchor) {
////                let error = ChanError.error(title: "Внимание", description: "Медиа содержит неприемлимый контент. ")
////                //
////                let display = ErrorDisplay(error: error, buttons: [.cancel, .custom(title: "Открыть", style: UIAlertAction.Style.default)])
////
////                display.show()
////                display
////                    .actions
////                    .subscribe(onNext: { [weak self, weak anchor] action in
////                        switch action {
////                        case .custom(_, _):
////                            if let model = anchor {
////                                self?.openMediaInBrowser(model)
////                            }
////                        default: break
////                        }
////                    })
////                    .disposed(by: self.disposeBag)
////            } else {
////
////                self.openMediaInBrowser(anchor)
////            }
//      #else
//        if anchor.type == .image {
//            let allFiles = self.data.flatMap { $0.files }.filter({ $0.type == .image })
//            let viewer = ThreadImageViewer(files: allFiles, anchor: anchor)
//            if let vc = viewer.browser {
//                self.router?.showMediaViewer(vc)
//            }
//        } else {
////            print(anchor.path)
////            if anchor.path.hasSuffix(".webm") { //}|| anchor.path.hasSuffix(".ogg") {
////                let webm = WebmPlayerViewController(with: anchor)
////                self.router?.showMediaViewer(webm)
////            } else {
////                let player = VideoPlayer(with: anchor)
////                if let pl = player.videoPlayer {
////                    self.router?.showMediaViewer(pl)
////                }
////            }
//        }

//      #endif

        
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
    
    private func openVideoExternal(url: String) {
        if VLCOpener.hasVLC() {
            VLCOpener.openInVLC(url: url)
        } else {
            let error = ChanError.error(title: "video_open_title".localized, description: "video_open_message".localized)

            let display = ErrorDisplay(error: error, buttons: [.cancel, .custom(title: "open_in_browser".localized, style: UIAlertAction.Style.default), .custom(title: "vlc_in_app_store".localized, style: UIAlertAction.Style.default)])

            display
                .actions
                .subscribe(onNext: { action in
                    switch action {
                    case .custom(let title, _):
                        if title.lowercased() == "vlc_in_app_store".localized.lowercased() {
                            Helper.openInSafari(url: URL(string: "itms-apps://itunes.apple.com/app/id650377962"))
                        } else {
                            Helper.open(url: URL(string: url))
                        }
                    default: break
                    }
                })
                .disposed(by: self.disposeBag)

            display.show()


        }

    }
    
    
    private func copyLinkOnThread() {
        if let url = self.thread?.url {
            UIPasteboard.general.string = url
            ErrorDisplay.presentAlert(with: "link_copied".localized, message: url, dismiss: SmallDismissTime)
        } else {
            ErrorDisplay.presentAlert(with: nil, message: "link_copy_error".localized, dismiss: SmallDismissTime)
        }
    }
    
    private func openMediaInBrowser(_ media: MediaModel) {
        Helper.open(url: media.url)
        
    }
    
    private func changeFavorite() {
        if let thread = self.thread {
            if thread.type == .favorited {
                thread.type = .history
            } else {
                thread.type = .favorited
            }
            
            self.favoriteService?.write(thread: thread)
            self.updateMainModel()
            
        }
    }

}
