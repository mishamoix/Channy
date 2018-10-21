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
        
        self.mainViewModel.value = BoardMainViewModel(title: self.service.board.name)
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setup()
        
        self.presenter.showCentralActivity()
        self.load(reload: true)
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
                    self?.load()
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
    


}
