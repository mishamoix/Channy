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
    
    func openAgreement(model: WebAcceptViewModel)
    func closeAgreement()
    
    func openCreateThread(_ thread: ThreadModel)
    func closeCreateThread()
    
    
}

protocol BoardPresentable: Presentable {
    var listener: BoardPresentableListener? { get set }
    var vc: UIViewController { get }
    var isVisible: Bool { get }
    
    func stopLoadersAfterRefresh()
    var serachActive: Bool { get }

    func scrollToTop()
    func deactivateSearch()

}

protocol BoardListener: class {
    
    func openMenu()
    
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol BoardInputProtocol {
    func open(thread: ThreadModel)
    func deactivateSearch()
    func scrollToTop()
}

final class BoardInteractor: PresentableInteractor<BoardPresentable>, BoardInteractable, BoardPresentableListener, BoardInputProtocol {
    


    weak var router: BoardRouting?
    weak var listener: BoardListener?
    
    private var imageboardService: ImageboardCurrentProtocol
    private var service: BoardServiceProtocol
    private let disposeBag = DisposeBag()
    
    private var data: [ThreadModel] = []
    private var viewModels: [ThreadViewModel] = []
    
    private var favoriteService: WriteMarkServiceProtocol
    
    private var currentModel: BoardModel? = nil
    
    private var isFirst = true
    
    private var isLoading = false
    private var checkLinkPopupOpened = false
    private var currentSaerchString: String? = nil
    
    var updateSearchObservable: Variable<String?> = Variable<String?>(nil)
    
    private var prevLinkFromBuffer: String? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardPresentable, imageboardService: ImageboardCurrentProtocol, service: BoardServiceProtocol, favoriteService: WriteMarkServiceProtocol) {
        self.imageboardService = imageboardService
        self.service = service
        self.favoriteService = favoriteService
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
    
    // MARK: BoardPresentableListener
    var mainViewModel: Variable<BoardMainViewModel> = Variable(BoardMainViewModel(name: "", board: ""))
    var dataSource: Variable<[ThreadViewModel]> = Variable([])
    var viewActions: PublishSubject<BoardAction> = PublishSubject()

    // MARK: ThreadListener
    func popToRoot(animated: Bool) {}
    func reply(postUid: Int) {}
    
    
    // MARK: BoardInputProtocol
    
    func open(thread: ThreadModel) {
        self.router?.open(thread: thread)
    }
    
    func deactivateSearch() {
        self.presenter.deactivateSearch()
    }
    
    func scrollToTop() {
        self.presenter.scrollToTop()
    }
    
    // MARK: Private
    func setup() {
        self.setupRx()
    }
    
    func load(reload: Bool = false) {
        
        guard let board = self.currentModel else {
            self.presenter.stopAnyLoaders()
            self.listener?.openMenu()
            
//            let error = ChanError.error(title: "", description: "need_select_imageboard_and_board".localized)
//            ErrorDisplay(error: error, buttons: [.ok]).show(on: self.presenter.vc)
            return
        }
        
        if self.isLoading && !reload { return }
        self.isLoading = true
 

        
        StatisticManager.openBoard(model: board)
        
        self.service
            .loadThreads(board: board)
            .asObservable()
            .observeOn(Helper.rxBackgroundThread)
            .retryWhen({ [weak self] errorObservable in
                return errorObservable.flatMap({ error -> Observable<Void>  in

                    if let err = error as? ChanError, err == ChanError.noModel {
                        let noModelError = ChanError.error(title: "Введите код доски ", description: "Вы еще не добавили домашнюю доску 😱, введите код доски")
                        let display = ErrorDisplay(error: noModelError, buttons: [.input(result: "Например pr")])

                        Helper.performOnMainThread {
                            self?.presenter.stopAnyLoaders()
                            display.show(on: self?.presenter.vc)
                        }

                        return display.actions
                            .flatMap({ action -> Observable<Void> in
                                switch action {
                                case .input(let result): do {
                                    if let result = TextStripper.onlyChars(text: result) {
//                                        self?.service.saveBoardAsHomeIfSuccess = true
//                                        let board = BoardModel(uid: result)
//                                        self?.service.update(board: board)
//                                        self?.updateHeader()
                                    }
                                }
                                    default: break
                                }
                                self?.load(reload: true)
                                self?.presenter.showCentralActivity()
                                return Observable<Void>.error(ChanError.noModel)
                            })
                    } else {


                        let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])

                        Helper.performOnMainThread {
                            self?.presenter.stopAnyLoaders()
                            errorManager.show(on: self?.presenter.vc)
                        }

                        return errorManager.actions
                            .flatMap({ type -> Observable<Void> in
                                if type == .retry {
                                    self?.presenter.showCentralActivity()
                                    return Observable<Void>.just(Void())
                                } else {
                                    self?.presenter.stopAnyLoaders()
                                    return Observable<Void>.empty()
                                }
                            })
                    }
                })
            })
            .subscribe(onNext: { [weak self] models in
                if reload {
                    Helper.performOnMainThread {
                        self?.presenter.scrollToTop()
                    }
                }

                let _ = models.map({ $0.board = self?.currentModel })
                
                self?.isLoading = false
                self?.checkAgreement()
                
                let viewModels = AdsBoardListManager(threads: models.map({ ThreadViewModel(with: $0)})).prepareAds()
                
                
                self?.data = models
                self?.viewModels = viewModels
                
                self?.updateData()
                
                self?.presenter.stopLoadersAfterRefresh()
                
            }, onError: { [weak self] err in
                self?.isLoading = false
                self?.presenter.stopAnyLoaders()
            })
            .disposed(by: self.service.disposeBag)

    }
    
    func setupRx() {
        
        
        self.imageboardService
            .currentBoard()
            .subscribe(onNext: { [weak self] board in
                self?.currentModel = board
                self?.updateHeader()
                
                self?.stopAndReload()
            })
            .disposed(by: self.disposeBag)
        
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .loadNext: do {
                    if self?.data.count ?? 0 != 0 {
//                        self?.load()
                    }
                }
                case .openThread(let uid): do {
                    if let thread = self?.findThread(by: uid) {
                        self?.router?.open(thread: thread)
                    }
                }
                case .reload: do {
//                    self?.service.cancel()
                    self?.load(reload: true)
                    }

                case .goToNewBoard: do {

                }

                case .openHome: do {
                    self?.presenter.stopAnyLoaders()
//                    self?.service.cancel()

                    self?.listener?.openMenu()
                }

                case .copyLinkOnBoard: do {
                }
                case .viewWillAppear: self?.viewWillAppear()
                case .openByLink: self?.openByLink()
                case .createNewThread:
                    break
//                    let thread = ThreadModel(uid: "", board: self?.service.board)
//                    self?.router?.openCreateThread(thread)
                    
                case .addToFavorites(let uid): do {
                    guard let self = self else { return }
                        if let model = self.findThread(by: uid) {
                        if model.type == .favorited {
                            model.type = .none
                        } else {
                            model.type = .favorited
                        }
                        self.favoriteService.write(thread: model)
                        if let idx = self.findThreadViewModelIdx(by: uid) {
                            self.viewModels[idx] = ThreadViewModel(with: model)
                        }
                            
                        self.updateData()
//                        self.dataSource.value = self.viewModels
                        
                        self.favoriteService.write(thread: model)
                    }
                    
                }
                    
                case .hide(let uid): do {
                    guard let self = self else { return }
                    
                    if HiddenThreadManager.shared.hidden(uid: uid) {
                        HiddenThreadManager.shared.remove(thread: uid)
                    } else {
                        HiddenThreadManager.shared.add(thread: uid)
                    }
                    
                    self.updateData()
//                    let model = self.data[idx]
//                    model.
                    
                }
                }
                

            }).disposed(by: self.disposeBag)
        
        
        AppDependency
            .shared
            .appAction
            .subscribe(onNext: { [weak self] action in
                self?.detectUrlAfterOpenApp()
            })
            .disposed(by: self.disposeBag)
        
        
        self.updateSearchObservable.asObservable().debounce(0.3, scheduler: Helper.rxMainThread).subscribe(onNext: { [weak self] _ in
            self?.updateData()
        }).disposed(by: self.disposeBag)
    }
    
    
    // MARK: BoardsListListener
    func open(board: BoardModel) {
        self.isLoading = false
//        self.service.cancel()
//        self.service.update(board: board)
//        self.load(reload: true)
        self.presenter.showCentralActivity()
        
        self.router?.closeCreateThread()
    }
    
    func closeBoardsList() {
    }
    
    // MARK: WebAcceptListener
    func accept() {
        Values.shared.privacyPolicy = true
        self.router?.closeAgreement()
    }
    
    // MARK: WriteListener
    func messageWrote(model: WriteResponseModel) {
//        self.router?.closeCreateThread()
//
//        switch model {
//        case .threadCreated(let threadUid):
////            let thread = ThreadModel(uid: threadUid, board: self.service.board)
////            self.router?.open(thread: thread)
//        default: break
//        }
        
        self.load(reload: true)
    }
    
    
    // MARK: Private
    private func viewWillAppear() {
        if self.isFirst {
            self.isFirst = false
//            self.initialLoad()

        }
    }
    
    func updateData() {
        self.dataSource.value = self.filterThreads(view: self.viewModels, isActive: self.presenter.serachActive, search: self.updateSearchObservable.value)
    }
    
    func filterThreads(view models: [ThreadViewModel], isActive: Bool, search text: String?) -> [ThreadViewModel] {
        
        if !isActive {
            let result = models.map({ model -> ThreadViewModel in
                model.hidden = HiddenThreadManager.shared.hidden(uid: model.uid)
                model.needReload = true
                return model
            })

            return result
        }
        
        guard let text = text, text.count > 0 else {
            return models
        }
        
        let searchText = text.lowercased()
        
        var result = models.filter({ ($0.displayText?.lowercased().contains(searchText) ?? false) || ($0.title?.lowercased().contains(searchText) ?? false) })
        result = models.map({ model -> ThreadViewModel in
            model.hidden = HiddenThreadManager.shared.hidden(uid: model.uid)
            return model
        })

        return result
    }
    
    func openBoardSelection() {
        
    }
    
    private func stopAndReload() {
        self.presenter.hideCentralActivity()
        self.presenter.showCentralActivity()
        self.service.cancel()
        self.load(reload: true)
    }
    
    
    private func initialLoad() {
        self.presenter.showCentralActivity()
//        self.load(reload: true)
    }
    
    private func updateHeader() {
        if let board = self.currentModel {
            self.mainViewModel.value = BoardMainViewModel(name: board.name, board: "/" + board.id)
        }
    }
    
    private func checkAgreement() {
//        if !Values.shared.privacyPolicy {
//            if let url = FirebaseManager.shared.agreementUrl {
//                let agreement = WebAcceptViewModel(url: url, title: "Agreement".localized)
//                
//                Helper.performOnMainThread {
//                    self.router?.openAgreement(model: agreement)
//                }
//            }
//        }
    }
    
    private func openByLink() {
//        let error = ChanError.error(title: "Открытие по ссылке", description: "Введите ссылку и мы попытаемся открыть тред или доску")
//        let display = ErrorDisplay(error: error, buttons: [.input(result: "Например 2ch.hk/pr/res/999999"), .cancel])
//        display.show()
//        display
//            .actions
//            .subscribe(onNext: { action in
//                switch action {
//                case .input(let result):
//                    self.openUrlIfCan(url: result)
//                default: break
//                }
//            })
//            .disposed(by: self.disposeBag)
    }
    
    private func detectUrlAfterOpenApp() {
        return
//        print(self.checkLinkPopupOpened)
//        if !self.isLoading && self.presenter.isVisible && !self.checkLinkPopupOpened {
//            let link = UIPasteboard.general.string
//            
//            if let model = self.canOpenChan(url: link), self.prevLinkFromBuffer != link {
//                if model.board != nil || (model.thread != nil && model.board != nil) {
//                    
////                    if let board = model.board, let currentBoard = self.service.board, model.thread == nil && currentBoard.uid == board {
//////                        if  {
////                            return
//////                        }
////                    }
////                    if let board = model.board, let currentBoard = self.service.board, model.thread == nil, currentBoard.uid == board {
////                        return
////                    }
//                    
//                    let error = ChanError.error(title: "Открытие по ссылке", description: "В буфере обмена мы обнаружили ссылку на Двач, перейти по ней?")
//                    self.checkLinkPopupOpened = true
//                    let display = ErrorDisplay(error: error, buttons: [.ok, .cancel])
//                    display.show()
//                    self.prevLinkFromBuffer = link
//                    display
//                        .actions
//                        .subscribe(onNext: { action in
//                            switch action {
//                            case .ok: self.openUrlIfCan(url: link)
//                            default: break
//                            }
//                            
//                            self.checkLinkPopupOpened = false
//                        })
//                        .disposed(by: self.disposeBag)
//                }
//            }
//        }
//        

    }
    
    private func openUrlIfCan(url: String?) {
        if let model = self.canOpenChan(url: url) {
            
            if let boardUid = model.board, let threadUid = model.thread {
                let board = BoardModel(uid: boardUid)
                let thread = ThreadModel(uid: threadUid, board: board)
//                thread.currentPost = model.post
                self.router?.open(thread: thread)
            } else if let boardUid = model.board {
                let board = BoardModel(uid: boardUid)
//                self.service.cancel()
//                self.service.update(board: board)
                self.load(reload: true)
                self.presenter.showCentralActivity()
            }
        }
    }
    
    private func canOpenChan(url: String?) -> ChanLinkModel? {
        guard let url = url else {
            return nil
        }
        
        let parser = LinkParser(path: url)
        parser.processType()
        switch parser.type {
        case .boardLink(let model):
            return model
        default:
            return nil
        }
    }
    
    private func findThread(by uid: String) -> ThreadModel? {
        return self.data.first(where: { $0.id == uid })
    }
    
    private func findThreadViewModelIdx(by uid: String) -> Int? {
        return self.viewModels.firstIndex(where: { $0.uid == uid })
    }

}
