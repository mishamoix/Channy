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
     func openBoard(with board: BoardModel)
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
    
    // MARK: Private
    private func setup() {
        self.setupRx()
    }
    
    private func setupRx() {
        
//        self.subscribeOnService()
        self.viewActions
            .asObservable()
            .observeOn(Helper.rxBackgroundThread)
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .seacrh(let text): do {
                    if let result = self?.search(with: text) {
                        self?.dataSource.value = result
                    }
                    }
                case .openBoard(let index): do {
                    if let model = self?.dataSource.value[index.section].boards[index.row] {
                        self?.router?.openBoard(with: model)
                    }
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
//    private func subscribeOnService() {
//
//        self.listServiceResult = PublishSubject<BoardsListServiceProtocol.ResultType>()
//        self.listService.publish = self.listServiceResult
//
//        self.listServiceResult
//            .observeOn(Helper.rxBackgroundThread)
//            .retryWhen({ (errorOsb: Observable<Error>) in
//                return errorOsb.flatMap({ error -> Observable<()>  in
//                    let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry])
//                    errorManager.show()
//
//                    return errorManager.actions
//                        .filter({ $0 == .retry })
//                        .flatMap({ type -> Observable<()> in
////                            self?.subscribeOnService()
////                            self?.reload()
//                            return Observable<()>.just(()).asObservable().delay(1.0, scheduler: Helper.rxBackgroundThread)
////                            return Observable<[BoardCategoryModel]?>.just(nil)
//                        })
//
////                    return Observable<()>.just(()).asObservable().delay(10.0, scheduler: Helper.rxBackgroundThread)
//                })
//            })
//            .catchError({ [weak self] error -> Observable<[BoardCategoryModel]?> in
//                let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry])
//                errorManager.show()
//
//                return errorManager.actions
//                    .filter({ $0 == .retry })
//                    .flatMap({ type -> Observable<[BoardCategoryModel]?> in
//                        self?.subscribeOnService()
//                        self?.reload()
//                        return Observable<[BoardCategoryModel]?>.just(nil)
//                    })
//            })
//            .flatMap({  [weak self] (result) -> Observable<[BoardCategoryModel]> in
//                if let result = result {
//                    let sorted = result
//                        .sorted(by: { $0.name ?? "" < $1.name ?? "" })
//                    for category in sorted {
//                        category.boards = category.boards.sorted(by: { $0.uid < $1.uid })
//                    }
//
//                    self?.data = sorted
//                    return Observable<[BoardCategoryModel]>.just(sorted)
//                }
//
//                return Observable<[BoardCategoryModel]>.just([])
//            })
//            .bind(to: self.dataSource)
//            .disposed(by: self.disposeBag)
//
//    }
    
    private func search(with text: String?) -> [BoardCategoryModel] {
        var result: [BoardCategoryModel] = []
        
        guard let text = text else {
            return self.data
        }
        
        if text.count == 0 {
            return self.data
        }
        
        for section in self.data {
            if let copySection  = section.copy() as? BoardCategoryModel {
                copySection.boards = section.boards.filter { $0.has(substring: text) }
                
                if copySection.boards.count > 0 || copySection.has(substring: text) {
                    result.append(copySection)
                }
            }
            
        }
        
        return result
    }
    
    private func reload() {
        self.listService.loadAllBoards()
            .observeOn(Helper.rxBackgroundThread)
            .retryWhen({ (errorOsb: Observable<Error>) in
                return errorOsb.flatMap({ error -> Observable<()>  in
                    let errorManager = ErrorManager.errorHandler(for: self, error: error, actions: [.retry])
                    errorManager.show()
                    
                    return errorManager.actions
                        .filter({ $0 == .retry })
                        .flatMap({ type -> Observable<()> in
                            return Observable<()>.just(())
                        })

                })
            })
            .flatMap({  [weak self] (result) -> Observable<[BoardCategoryModel]> in
                if let result = result {
                    let sorted = result
                        .sorted(by: { $0.name ?? "" < $1.name ?? "" })
                    for category in sorted {
                        category.boards = category.boards.sorted(by: { $0.uid < $1.uid })
                    }
                    
                    self?.data = sorted
                    return Observable<[BoardCategoryModel]>.just(sorted)
                }
                
                return Observable<[BoardCategoryModel]>.just([])
            })
            .bind(to: self.dataSource)
            .disposed(by: self.disposeBag)

    }
}
