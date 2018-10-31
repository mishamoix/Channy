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
    
    func openBoardList()
    func closeBoardsList()
    
    func openAgreement(model: WebAcceptViewModel)
    func closeAgreement()
}

protocol BoardPresentable: Presentable {
    var listener: BoardPresentableListener? { get set }
    var vc: UIViewController { get }
}

protocol BoardListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BoardInteractor: PresentableInteractor<BoardPresentable>, BoardInteractable, BoardPresentableListener {

    weak var router: BoardRouting?
    weak var listener: BoardListener?
    
    private var service: BoardServiceProtocol
    private let disposeBag = DisposeBag()
    
    private var data: [ThreadModel] = []
    private var viewModels: [ThreadViewModel] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardPresentable, service: BoardServiceProtocol) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
        
        self.presenter.showCentralActivity()
        self.initialLoad()
//        self.load(reload: true)
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
        self.setupRx()
    }
    
    func load(reload: Bool = false) {
        
        self.service
            .loadNext(realod: reload)?
            .asObservable()
            .observeOn(Helper.rxBackgroundThread)
            .retryWhen({ [weak self] errorObservable in
                return errorObservable.flatMap({ error -> Observable<Void>  in
                    
                    if let err = error as? ChanError, err == ChanError.noModel {
                        self?.presenter.stopAnyLoaders()
                        let noModelError = ChanError.error(title: "Введите код доски ", description: "Вы еще не добавили домашнюю доску 😱, введите код доски")
                        let display = ErrorDisplay(error: noModelError, buttons: [.input(result: "Например pr")])
                        display.show()
                        
                        return display.actions
                            .flatMap({ action -> Observable<Void> in
                                switch action {
                                case .input(let result): do {
                                    if let result = TextStripper.onlyChars(text: result) {
                                        self?.service.saveBoardAsHomeIfSuccess = true
                                        let board = BoardModel(uid: result)
                                        self?.service.update(board: board)
                                        self?.updateHeader()
                                        
                                    }
                                }
                                    default: break
                                }
                                self?.load()
                                self?.presenter.showCentralActivity()
                                return Observable<Void>.error(ChanError.noModel)
                            })
                    } else {
                        self?.presenter.stopAnyLoaders()

                        let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])
                        errorManager.show(on: self?.presenter.vc)
                        
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
            .flatMap({ [weak self] result -> Observable<[ThreadViewModel]> in
                self?.checkAgreement()
                self?.updateHeader()
                let threads = result.result.filter({ !FirebaseManager.shared.excludeThreads.contains($0.threadPath) })
                let threadsVM = threads
                    .map({ ThreadViewModel(with: $0) })
                
                var allVM: [ThreadViewModel] = []
                if let prev = self?.viewModels {
                    allVM += prev
                }
            
                switch result.type {
                case .first:
                    self?.data = threads
                    allVM = threadsVM
                    self?.viewModels = threadsVM
                default:
                    self?.viewModels += threadsVM
                    self?.data += threads
                    allVM += threadsVM
                }
                self?.presenter.stopAnyLoaders()
                return Observable<[ThreadViewModel]>.just(allVM)
            })
            .subscribe(onNext: { [weak self] models in
                self?.dataSource.value = models
            })
            .disposed(by: self.disposeBag)
    }
    
    func setupRx() {
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .loadNext: do {
                    if self?.data.count ?? 0 != 0 {
                        self?.load()
                    }
                }
                case .openThread(let idx): do {
                    if let thread = self?.data[idx] {
                        self?.router?.open(thread: thread)
                    }
                }
                case .reload: do {
                    self?.service.cancel()
                    self?.load(reload: true)
                    }
                    
                case .goToNewBoard: do {
                    
                }
                    
                case .openHome: do {
                    self?.presenter.stopAnyLoaders()
                    self?.service.cancel()
                    self?.router?.openBoardList()
                }
                    
                case .copyLinkOnBoard: do {
                    if let link = self?.service.board?.buildLink {
                        UIPasteboard.general.string = link
                        ErrorDisplay.presentAlert(with: "Ссылка скопирована!", message: link, dismiss: SmallDismissTime)
                        
                    } else {
                        ErrorDisplay.presentAlert(with: nil, message: "Ошибка копирования ссылки", dismiss: SmallDismissTime)
                    }

                }
                }
            }).disposed(by: self.disposeBag)
    }
    
    
    // MARK: BoardsListListener
    func open(board: BoardModel) {
        self.service.update(board: board)
        self.load(reload: true)
        self.presenter.showCentralActivity()
    }
    
    func closeBoardsList() {
        self.router?.closeBoardsList()
    }
    
    // MARK: WebAcceptListener
    func accept() {
        Values.shared.privacyPolicy = true
        self.router?.closeAgreement()
    }
    
    private func initialLoad() {
        self.load(reload: true)
        self.updateHeader()
    }
    
    private func updateHeader() {
        if let board = self.service.board {
            self.mainViewModel.value = BoardMainViewModel(title: board.name.count == 0 ? board.uid : board.name)
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

}
