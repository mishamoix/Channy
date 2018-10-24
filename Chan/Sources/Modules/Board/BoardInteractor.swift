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
        
        self.mainViewModel.value = BoardMainViewModel(title: "")
        
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
                                    case .input(let result): print(result)
                                    default: break
                                }
                                self?.presenter.showCentralActivity()
                                return Observable<Void>.just(Void())
                            })
                    } else {
                        let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry, .ok])
                        errorManager.show()
                        
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
            .bind(to: self.dataSource)
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
                }
            }).disposed(by: self.disposeBag)
    }
    
//    .flatMap { model -> Observable<BoardModel?> in
//    if model == nil {
//    let err = ChanError.noHomeModel
//    let display = ErrorDisplay(error: err, buttons: [.input(result: nil)])
//    display.show()
//
//    return display.actions.flatMap({ action -> Observable<BoardModel?> in
//    switch action {
//    case .input(let result): print(result)
//    default: break
//    }
//
//    return Observable<BoardModel?>.just(nil)
//    })
//    } else {
//    return Observable<BoardModel?>.just(model)
//    }
//    }
    
    
    private func initialLoad() {
        self.service
            .fetchHomeBoard()
            .subscribe(onNext: { [weak self] model in
                if let model = model {
                    self?.service.update(board: model)
                }
                
                self?.load()
            })
            .disposed(by: self.service.disposeBag)
    }
    


}
