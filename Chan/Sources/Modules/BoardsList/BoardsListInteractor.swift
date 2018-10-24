//
//  BoardsListInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol BoardsListRouting: ViewableRouting {
//    func openBoard(with board: BoardModel)
//    func openSettings()
//    
//    func openAgreement(model: WebAcceptViewModel)
//    func closeAgreement()
}

protocol BoardsListPresentable: Presentable {
    var listener: BoardsListPresentableListener? { get set }
}

protocol BoardsListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BoardsListInteractor: PresentableInteractor<BoardsListPresentable>, BoardsListInteractable, BoardsListPresentableListener {

    

    weak var router: BoardsListRouting?
    weak var listener: BoardsListListener?
    
    private var listService: BoardsListServiceProtocol
    private var listServiceResult: PublishSubject<BoardsListServiceProtocol.ResultType> = PublishSubject<BoardsListServiceProtocol.ResultType>()
    
    private let disposeBag = DisposeBag()
    private var data: [BoardCategoryModel] = []
    
    private var currentSearchText: String? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardsListPresentable, list: BoardsListServiceProtocol) {
        self.listService = list

        super.init(presenter: presenter)
        presenter.listener = self
        
        self.setup()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.reload()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: BoardsListPresentableListener
    let dataSource = Variable<[BoardCategoryModel]>([])
    var viewActions: PublishSubject<BoardsListAction> = PublishSubject()
    
    // MARK: SettingsListener
    func limitorChanged() {
        self.load()
    }
    
    // MARK: WebAcceptDependency
    func accept() {
//        self.router?.closeAgreement()
//        Values.shared.privacyPolicy = true
    }
    
    func endRefreshing() {
        
    }
    
    // MARK: Private
    private func setup() {
        self.setupRx()
    }
    
    private func setupRx() {
//        self.viewActions
//            .asObservable()
//            .observeOn(Helper.rxMainThread)
//            .subscribe(onNext: { [weak self] action in
//                switch action {
//                case .seacrh(let text): do {
//                    self?.currentSearchText = text
//                    if let result = self?.search(with: text) {
//                        self?.dataSource.value = result
//                    }
//                }
//                case .openBoard(let index): do {
//                    if let model = self?.dataSource.value[index.section].boards[index.row] {
//                        self?.router?.openBoard(with: model)
//                    }
//                }
//                case .openSettings: do {
//                    self?.router?.openSettings()
//                }
//                }
//            }).disposed(by: self.disposeBag)
    }
    
    
    private func search(with text: String?) -> [BoardCategoryModel] {
        var result: [BoardCategoryModel] = []
        
        guard let text = text else {
            return self.data
        }
        
        if text.count == 0 {
            return self.data
        }
        
        for section in self.data {
            let copySection  = section.cp()
            copySection.boards = section.boards.filter { $0.has(substring: text) }
            
            if copySection.boards.count > 0 || copySection.has(substring: text) {
                result.append(copySection)
            }
        }
        
        return result
    }
    
    private func reload() {
        self.listService.dropCache()
        self.load()
    }
    
    private func load() {
        
//        self.listService.cancel()
//
//        self.presenter.showCentralActivity()
//        self.listService
//            .loadAllBoards()
//            .observeOn(Helper.rxBackgroundThread)
//            .retryWhen({ (errorOsb: Observable<Error>) in
//                return errorOsb.flatMap({ error -> Observable<Void>  in
//                    let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry])
//                    errorManager.show()
//
//                    return errorManager.actions
//                        .filter({ $0 == .retry })
//                        .flatMap({ type -> Observable<()> in
//                            return Observable<Void>.just(Void())
//                        })
//
//                })
//            })
//            .flatMap({  [weak self] (result) -> Observable<[BoardCategoryModel]> in
//                self?.checkAgreement()
//                if let result = result {
//
//                    var res: [BoardCategoryModel] = []
//
//                    for category in result {
//                        let cat = category.cp()
//                        cat.boards = category.boards
//                            .filter({ !FirebaseManager.shared.excludeBoards.contains($0.uid) })
//                            .sorted(by: { $0.uid < $1.uid })
//                        res.append(cat)
//                    }
//
//                    if let allow = FirebaseManager.shared.notFullAllowBoards, Values.shared.safeMode {
//                        for category in res {
//                            category.boards = category.boards
//                                .filter({ allow.contains($0.uid) })
//                        }
//                    }
//
//                    let sorted = res
//                        .filter({ $0.boards.count != 0 })
//                        .sorted(by: { $0.name ?? "" < $1.name ?? "" })
//
//                    self?.data = sorted
//                    self?.presenter.stopAnyLoaders()
//                    return Observable<[BoardCategoryModel]>.just(self?.search(with: self?.currentSearchText) ?? [])
//                }
//
//                self?.presenter.stopAnyLoaders()
//                return Observable<[BoardCategoryModel]>.just([])
//            })
//            .bind(to: self.dataSource)
//            .disposed(by: self.listService.disposeBag)

    }
    
    private func checkAgreement() {
//        if !Values.shared.privacyPolicy {
//            if let url = FirebaseManager.shared.agreementUrl {
//                let agreement = WebAcceptViewModel(url: url, title: "Соглашение")
//                
//                Helper.performOnMainThread {
//                    self.router?.openAgreement(model: agreement)
//                }
//            }
//        }
    }
}
