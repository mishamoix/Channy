//
//  BoardService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift


protocol BoardServiceProtocol: BaseServiceProtocol {
    typealias DataType = ThreadModel
    typealias ResultType = [DataType]
//
//
//    var board: BoardModel? { get }
//
//    func loadNext(realod needReload: Bool) -> Observable<ResultType>?
//    func update(board: BoardModel)
//
//    var saveBoardAsHomeIfSuccess: Bool { get set }
//
//    func reset()
    
    
    func loadThreads(board: BoardModel) -> Observable<ResultType>
    
}


class BoardService: BaseService, BoardServiceProtocol {
    
    private let provider = ChanProvider<BoardTarget>()
    
    
    func loadThreads(board: BoardModel) -> Observable<ResultType> {
        
        guard let imageboard = board.imageboard else {
            
            return Observable<ResultType>.error(ChanError.error(title: "Ошибка", description: "Произошла непредвиденная ошибка, перезапустите приложение"))
        }
        
        return self.provider
            .rx
            .request(.mainPage(board: String(board.id), imageboard: String(imageboard.id)))
            .asObservable()
            .map({ [weak self] response -> ResultType in
                
                guard let self = self else { return [] }
                
                let models = self.makeModel(data: response.data)
                return models
//                return []
            })
    }
    
//    var board: BoardModel?
//    var saveBoardAsHomeIfSuccess: Bool {
//        get {
//            return self.needUpdatedBoard
//        }
//
//        set {
//            self.needUpdatedBoard = newValue
//        }
//    }
    
//    private var needUpdatedBoard = false
//
//    private let provider = ChanProvider<BoardTarget>()
//
//    private var page = 0
//    private var maxPage = 1
//
//    private var onLoading = false
//
//    private let boardsListService = BoardsListService()
//
//
//    func update(board: BoardModel) {
//        self.board = board
//    }
//
//    func loadNext(realod needReload: Bool = false) -> Observable<ResultType>? {
//
//        if self.board == nil {
//            self.board = self.boardsListService.home
//        }
//
//        guard let board = self.board else {
//
//            return Observable<ResultType>.error(ChanError.noModel)
//        }
//
//        let uid = board.uid
//
//        if needReload {
//            self.reset()
//        }
//
//        if (self.page < self.maxPage) {
//            self.onLoading = true
//
//            var target: BoardTarget
//            if self.page == 0 {
//                target = .mainPage(board: uid)
//            } else {
//                target = .page(board: uid, page: self.page)
//            }
//
//            return self.provider
//                .rx
//                .request(target)
//                .asObservable()
//                .retry(RetryCount)
//                .flatMap({ [weak self] response -> Observable<ResultType> in
//                    self?.onLoading = false
//
//
//                    if FirebaseManager.shared.needExcludeBoards {
//                        if let uid = self?.board?.uid, FirebaseManager.shared.excludeBoards.contains(uid) {
//                            return Observable<ResultType>.error(ChanError.notFound)
//                        }
//                    }
//
//
//                    if let res = self?.makeModel(data: response.data) {
//                        var type: ResultBoardModelType = .first
//                        if let page = self?.page, page != 0 {
//                            type = .page(idx: page)
//                        }
//
//                        let result = ResultType(result: res, type: type)
//                        self?.page += 1
//
//                        self?.checkAndSaveHomeBoard()
//
//
//                        return Observable<ResultType>.just(result)
//                    } else {
//                        let result = ResultType(result: [], type: ResultBoardModelType.page(idx: self?.page ?? 0))
//                        self?.page += 1
//                        self?.checkAndSaveHomeBoard()
//                        return Observable<ResultType>.just(result)
//                    }
//                }).catchError({ (error) -> Observable<ResultType> in
//
//                    if let err = ErrorHelper(error: error).makeError() as? ChanError, let board = self.board {
//                        if err == .notFound {
//                            self.boardsListService.delete(board: board)
//                        }
//                    }
//
//                    return Observable<ResultType>.error(error)
//                })
//            }
//
//        return nil
//    }
//
//    private func checkAndSaveHomeBoard() {
//        if let board = self.board, self.needUpdatedBoard {
//            let _ = self.boardsListService.save(board: board)
//            self.saveBoardAsHomeIfSuccess = false
//        }
//    }
//
//
    private func makeModel(data: Data) -> ResultType {

        if let result = ThreadModel.parseArray(from: data) {
            return result
        }
        return []
//        if let json = self.fromJson(data: data) {
//            result = ThreadModel.parseArray(from: data)
//            if let boardName = json["BoardName"] as? String, let board = board, board.name.count == 0, boardName.count != 0 {
//                self.needUpdatedBoard = true
//                self.board?.name = boardName
//            }
//
//            if let pages = json["pages"] as? [Int] {
//                if let max = pages.max() {
//                    self.maxPage = max
//                }
//            }
//
//            if let threads = json["threads"] {
//                if let valueData = self.toJson(any: threads) {
//                    if let res = ThreadModel.parseArray(from: valueData) {
//                        let _ = res.map{ $0.update(board: self.board) }
//                        result = res
//                    }
//                }
//            }
//        }

//        return result

    }
//
//    func reset() {
//        self.page = 0
//        self.cancel()
//        self.onLoading = false
//        self.saveBoardAsHomeIfSuccess = false
//        self.maxPage = 1
//    }
//
//
//    override func cancel() {
//        super.cancel()
//        self.onLoading = false
//    }
//
    
    
    
}
