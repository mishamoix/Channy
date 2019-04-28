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

}

protocol BoardListener: class {
    
    func openMenu()
    
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BoardInteractor: PresentableInteractor<BoardPresentable>, BoardInteractable, BoardPresentableListener {


    weak var router: BoardRouting?
    weak var listener: BoardListener?
    
    private var imageboardService: ImageboardCurrentProtocol
    private var service: BoardServiceProtocol
    private let disposeBag = DisposeBag()
    
    private var data: [ThreadModel] = []
    private var viewModels: [ThreadViewModel] = []
    
    private var currentModel: BoardModel? = nil
    
    private var isFirst = true
    
    private var isLoading = false
    private var checkLinkPopupOpened = false
    
    
    private var prevLinkFromBuffer: String? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardPresentable, imageboardService: ImageboardCurrentProtocol, service: BoardServiceProtocol) {
        self.imageboardService = imageboardService
        self.service = service
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
    func reply(postUid: String) {}
    
    
    // MARK: Private
    func setup() {
        self.setupRx()
    }
    
    func load(reload: Bool = false) {
        if self.isLoading && !reload { return }
        self.isLoading = true
        guard let board = self.currentModel else {
            return
        }
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
                
                let _ = models.map({ $0.board = self?.currentModel })
                
                self?.isLoading = false
                self?.checkAgreement()
                
                let viewModels = models.map({ ThreadViewModel(with: $0)})
                
                self?.data = models
                self?.viewModels = viewModels
                
                self?.presenter.stopLoadersAfterRefresh()
                self?.dataSource.value = viewModels
//                self?.presenter.stopAnyLoaders()

                }, onError: { [weak self] err in
                    self?.isLoading = false
                    self?.presenter.stopAnyLoaders()
            })
            .disposed(by: self.service.disposeBag)

        
        
//        self.service
//            .loadNext(realod: reload)?
//            .asObservable()
//            .observeOn(Helper.rxBackgroundThread)
//            .retryWhen({ [weak self] errorObservable in
//                return errorObservable.flatMap({ error -> Observable<Void>  in
//
//                    if let err = error as? ChanError, err == ChanError.noModel {
//                        let noModelError = ChanError.error(title: "Введите код доски ", description: "Вы еще не добавили домашнюю доску 😱, введите код доски")
//                        let display = ErrorDisplay(error: noModelError, buttons: [.input(result: "Например pr")])
//
//                        Helper.performOnMainThread {
//                            self?.presenter.stopAnyLoaders()
//                            display.show(on: self?.presenter.vc)
//                        }
//
//                        return display.actions
//                            .flatMap({ action -> Observable<Void> in
//                                switch action {
//                                case .input(let result): do {
//                                    if let result = TextStripper.onlyChars(text: result) {
//                                        self?.service.saveBoardAsHomeIfSuccess = true
//                                        let board = BoardModel(uid: result)
//                                        self?.service.update(board: board)
//                                        self?.updateHeader()
//                                    }
//                                }
//                                    default: break
//                                }
//                                self?.load(reload: true)
//                                self?.presenter.showCentralActivity()
//                                return Observable<Void>.error(ChanError.noModel)
//                            })
//                    } else {
//
//
//                        let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])
//
//                        Helper.performOnMainThread {
//                            self?.presenter.stopAnyLoaders()
//                            errorManager.show(on: self?.presenter.vc)
//                        }
//
//                        return errorManager.actions
//                            .flatMap({ type -> Observable<Void> in
//                                if type == .retry {
//                                    self?.presenter.showCentralActivity()
//                                    return Observable<Void>.just(Void())
//                                } else {
//                                    self?.presenter.stopAnyLoaders()
//                                    return Observable<Void>.empty()
//                                }
//                            })
//                    }
//                })
//            })
//            .flatMap({ [weak self] result -> Observable<[ThreadViewModel]> in
//                self?.checkAgreement()
//                self?.updateHeader()
//              // TODO: переделать
//                let threads = result.result
//                  .filter({ !FirebaseManager.shared.excludeThreads.contains($0.threadPath) })
//                var threadsVM = threads
//                    .map({ ThreadViewModel(with: $0) })
//
//                var allVM: [ThreadViewModel] = []
//                if let prev = self?.viewModels {
//                    allVM += prev
//                }
//
//                switch result.type {
//                case .first:
//                    self?.data = threads
//                    allVM = threadsVM
//                    self?.viewModels = threadsVM
//
//                    if let uid = self?.service.board?.uid {
//                      StatisticManager.event(name: "loaded_board", values: ["uid" : uid])
//                    }
//                default:
//
//                    let prevThreads = (self?.data ?? []).map({ $0.uid })
//
//                    threadsVM = threadsVM.filter({ !prevThreads.contains($0.uid) })
//                    self?.viewModels += threadsVM
//                    self?.data += threads.filter({ !prevThreads.contains($0.uid) })
//                    allVM += threadsVM
//                }
//                self?.presenter.stopAnyLoaders()
//                return Observable<[ThreadViewModel]>.just(allVM)
//            })
//            .subscribe(onNext: { [weak self] models in
//                self?.dataSource.value = models
//                self?.isLoading = false
//            }, onError: { [weak self] _ in
//                self?.isLoading = false
//            })
//            .disposed(by: self.disposeBag)
//
//
//        self.updateHeader()

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
                case .openThread(let idx): do {
                    if let thread = self?.data[idx] {
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
//                    if let link = self?.service.board?.buildLink {
//                        UIPasteboard.general.string = link
//                        ErrorDisplay.presentAlert(with: "Ссылка скопирована!", message: link, dismiss: SmallDismissTime)
//
//                    } else {
//                        ErrorDisplay.presentAlert(with: nil, message: "Ошибка копирования ссылки", dismiss: SmallDismissTime)
//                    }

                }
                case .viewWillAppear: self?.viewWillAppear()
                case .openByLink: self?.openByLink()
                case .createNewThread:
                    break
//                    let thread = ThreadModel(uid: "", board: self?.service.board)
//                    self?.router?.openCreateThread(thread)
                    
                case .addToFavorites(let idx): do {
                    if let model = self?.data[idx] {
                        
                    }
                }
                    
                case .hide(let idx): do {
                    if let model = self?.data[idx] {
                        
                    }

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
            
            self.initialLoad()

        }
    }
    
    func openBoardSelection() {
        
    }
    
    private func stopAndReload() {
        self.presenter.showCentralActivity()
        self.service.cancel()
        self.load(reload: true)
    }
    
    
    private func initialLoad() {
        self.presenter.showCentralActivity()
        self.load(reload: true)
    }
    
    private func updateHeader() {
        if let board = self.currentModel {
            self.mainViewModel.value = BoardMainViewModel(name: board.name, board: "/" + board.id)
        }
    }
    
    private func checkAgreement() {
        if !Values.shared.privacyPolicy {
            if let url = FirebaseManager.shared.agreementUrl {
                let agreement = WebAcceptViewModel(url: url, title: "Соглашение")
                
                Helper.performOnMainThread {
                    self.router?.openAgreement(model: agreement)
                }
            }
        }
    }
    
    private func openByLink() {
        let error = ChanError.error(title: "Открытие по ссылке", description: "Введите ссылку и мы попытаемся открыть тред или доску")
        let display = ErrorDisplay(error: error, buttons: [.input(result: "Например 2ch.hk/pr/res/999999"), .cancel])
        display.show()
        display
            .actions
            .subscribe(onNext: { action in
                switch action {
                case .input(let result):
                    self.openUrlIfCan(url: result)
                default: break
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func detectUrlAfterOpenApp() {
        print(self.checkLinkPopupOpened)
        if !self.isLoading && self.presenter.isVisible && !self.checkLinkPopupOpened {
            let link = UIPasteboard.general.string
            
            if let model = self.canOpenChan(url: link), self.prevLinkFromBuffer != link {
                if model.board != nil || (model.thread != nil && model.board != nil) {
                    
//                    if let board = model.board, let currentBoard = self.service.board, model.thread == nil && currentBoard.uid == board {
////                        if  {
//                            return
////                        }
//                    }
//                    if let board = model.board, let currentBoard = self.service.board, model.thread == nil, currentBoard.uid == board {
//                        return
//                    }
                    
                    let error = ChanError.error(title: "Открытие по ссылке", description: "В буфере обмена мы обнаружили ссылку на Двач, перейти по ней?")
                    self.checkLinkPopupOpened = true
                    let display = ErrorDisplay(error: error, buttons: [.ok, .cancel])
                    display.show()
                    self.prevLinkFromBuffer = link
                    display
                        .actions
                        .subscribe(onNext: { action in
                            switch action {
                            case .ok: self.openUrlIfCan(url: link)
                            default: break
                            }
                            
                            self.checkLinkPopupOpened = false
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
        

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

}
