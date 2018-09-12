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
    private let listServiceResult: PublishSubject<BoardsListServiceProtocol.ResultType> = PublishSubject<BoardsListServiceProtocol.ResultType>()
    
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
        
        self.listService.loadAllBoards()
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
        self.listService.publish = self.listServiceResult
        self.listServiceResult.subscribe(onNext: { [weak self] (result) in
            if let result = result {
                self?.dataSource.value = result
                self?.data = result
            }
        }, onError: { error in
            
        }).disposed(by: self.disposeBag)
        
        self.viewActions.asObservable()
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
}
