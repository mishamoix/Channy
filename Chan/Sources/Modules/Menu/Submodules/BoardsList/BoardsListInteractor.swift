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
    func openSettings()
//
//    func openAgreement(model: WebAcceptViewModel)
//    func closeAgreement()
}

protocol BoardsListPresentable: Presentable {
    var listener: BoardsListPresentableListener? { get set }
}

protocol BoardsListListener: class {
    func open(board: BoardModel)
    func closeBoardsList()
    func openBoardSelection()
}

final class BoardsListInteractor: PresentableInteractor<BoardsListPresentable>, BoardsListInteractable, BoardsListPresentableListener {
    

    

    weak var router: BoardsListRouting?
    weak var listener: BoardsListListener?
    
    private let service: ImageboardListProtocol
//    private var listServiceResult: PublishSubject<BoardsListServiceProtocol.ResultType> = PublishSubject<BoardsListServiceProtocol.ResultType>()
    
    private let disposeBag = DisposeBag()
    private var data: [BoardModel] = []
    
    private var currentSearchText: String? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: BoardsListPresentable, list: ImageboardListProtocol) {
        self.service = list

        super.init(presenter: presenter)
        presenter.listener = self
        
        self.setup()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
//        self.reload()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: BoardsListPresentableListener
    let dataSource = Variable<ImageboardModel?>(nil)
    var viewActions: PublishSubject<BoardsListAction> = PublishSubject()
    
    // MARK: SettingsListener
    func limitorChanged() {
//        self.load()
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
        
        self.service
            .currentImageboard()
            .observeOn(Helper.rxMainThread)
            .bind(to: self.dataSource)
            .disposed(by: self.disposeBag)
        
        
        self.viewActions
            .asObservable()
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .openBoardsSelection: do {
                    self?.listener?.openBoardSelection()
                }
                case .openBoard(let model): do {
                    guard let self = self else { return }
                    self.service
                        .selectBoard(model: model)
                        .debug()
                        .subscribe({ _ in
                            self.listener?.open(board: model)
                        })
                        .disposed(by: self.disposeBag)
                }
                }
            })
            .disposed(by: self.disposeBag)
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
//                    if let models = self?.search(with: self?.currentSearchText), models.count > index.row {
//                        let model = models[index.row]
//                        self?.listener?.open(board: model)
//                        self?.listener?.closeBoardsList()
////                        self?.router?.openBoard(with: model)
//                    }
//                }
//                case .openSettings: do {
//                    self?.router?.openSettings()
//                }
//
//                case .addNewBoard: do {
//                    self?.addNewBoard()
//                }
//                case .close: do {
//                    self?.listener?.closeBoardsList()
//                }
//
//                case .delete(let uid): do {
//                    let board = BoardModel(uid: uid)
//                    self?.listService.delete(board: board)
//                    self?.load()
//                }
//                case .move(let from, let to): do {
//                    if let boards = self?.data {
//                        var brds = boards
//                        if from.row < boards.count && to.row < boards.count {
////                            if from.row > to.row {
////                                let reorderBoard = boards[from.row]
////                                brds.remove(at: from.row)
////                                brds.insert(reorderBoard, at: to.row)
////                            } else {
//                                let reorderBoard = boards[from.row]
//                                brds.remove(at: from.row)
//                                brds.insert(reorderBoard, at: to.row)
//
////                            }
//                            self?.listService.save(boards: brds)
//                        }
//                    }
//
//                    self?.load()
//                }
//                }
//            })
//            .disposed(by: self.disposeBag)
        
        
    }
    
    
    private func search(with text: String?) -> [BoardModel] {
        var result: [BoardModel] = []
        
        guard let text = text else {
            return self.data
        }
        if text.count == 0 {
            return self.data
        }
        result = self.data.filter({ $0.has(substring: text )})
        
        return result
    }
    
    private func reload() {
        self.load()
    }
    
    private func load() {
//        self.data = self.listService.loadCachedBoards()
//        self.dataSource.value = self.search(with: self.currentSearchText)
    }
    
    private func addNewBoard(title: String = "Добавление новой доски") {
//        let err = ChanError.error(title: title, description: "Введите название доски")
//
//        let display = ErrorDisplay(error: err, buttons: [.input(result: "Например pr"), .cancel])
//        display.show()
//
//        display
//            .actions
//            .subscribe(onNext: { [weak self] action in
//                switch action {
//                case .input(let result): do {
//                    if let uid = TextStripper.onlyChars(text: result) {
//                        let board = BoardModel(uid: uid)
//                        if self?.listService.save(board: board) ?? true {
//                            self?.load()
//                            return
//                        } else {
//                            self?.addNewBoard(title: "Доска \(board.uid) уже существует!")
//                            return
//                        }
//                    }
//                }
//                case .cancel: return
//                default: break
//                }
//
//                self?.addNewBoard(title: "Вы не ввели название доски!")
////                if let boardUid =
//            })
//            .disposed(by: self.disposeBag)
    }
    
//    private func checkAgreement() {
//        if !Values.shared.privacyPolicy {
//            if let url = FirebaseManager.shared.agreementUrl {
//                let agreement = WebAcceptViewModel(url: url, title: "Соглашение")
//                
//                Helper.performOnMainThread {
//                    self.router?.openAgreement(model: agreement)
//                }
//            }
//        }
//    }
}
