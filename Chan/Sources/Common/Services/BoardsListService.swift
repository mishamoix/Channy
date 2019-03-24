//
//  BoardsListService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Alamofire

protocol BoardsListServiceProtocol: BaseServiceProtocol {
    typealias ResultType = [BoardModel]
//    func loadAllBoards() -> Observable<ResultType>
//    func dropCache()
  
    func save(boards: [BoardModel])
    func save(board: BoardModel) -> Bool
    func delete(board: BoardModel)
    func loadCachedBoards() -> ResultType
    
    var home: BoardModel? { get }

    
    
}

class BoardsListService: BaseService, BoardsListServiceProtocol {
      
    private let provider = ChanProvider<BoardsListTarget>()
    
    private var cachedResult: [BoardCategoryModel]? = nil
    
    override init() {
        super.init()
    }
    
    var home: BoardModel? {
        return self.loadCachedBoards().first
    }
    
    func save(boards: [BoardModel]) {
        for (idx, board) in boards.enumerated() {
            board.sort = idx
        }
        CoreDataStore.shared.saveModels(with: boards, with: CoreDataBoard.self)
    }

    func save(board: BoardModel) -> Bool {
        var prevBoards = self.loadCachedBoards()
        var inserted = true
        if let findedIdx = prevBoards.firstIndex(where: { $0.uid == board.uid }) {
            inserted = false
            board.name = board.name.count == 0 ? prevBoards[findedIdx].name : board.name
            prevBoards.remove(at: findedIdx)
            prevBoards.insert(board, at: findedIdx)
        } else {
            prevBoards.append(board)
        }
        
        self.save(boards: prevBoards)
        
        return inserted
    }
    
    func delete(board: BoardModel) {
        CoreDataStore.shared.delete(with: CoreDataBoard.self, predicate: board.fetching)
        let cached = self.loadCachedBoards()
        self.save(boards: cached)
    }
    
    
    func loadCachedBoards() -> ResultType {
        let result = (CoreDataStore.shared.findModels(with: CoreDataBoard.self) as? [BoardModel] ?? []).sorted(by: { $0.sort < $1.sort })
        return result
    }
    
//    func loadAllBoards() -> Observable<ResultType> {
//
//        if self.cachedResult == nil {
//            return self.load()
//        } else {
//            return self.getCachedBoards()
//        }
//
//    }
//
//    func dropCache() {
//        self.cachedResult = nil
//    }
//
//    private func getCachedBoards() -> Observable<ResultType> {
//        return Observable<ResultType>.just(self.cachedResult)
//    }
//
//    private func load() -> Observable<ResultType> {
//        return self.provider
//            .rx
//            .request(.list)
//            .asObservable()
//            .retry(RetryCount)
//            .flatMap {[weak self] (response) -> Observable<ResultType> in
//                let res = self?.makeModels(data: response.data)
//                self?.cachedResult = res
//                return Observable<ResultType>.just(res)
//        }
//
//    }
//
//    private func makeModels(data: Data) -> ResultType {
//        var result: ResultType = []
//
//        if let json = self.fromJson(data: data) {
//            for (key, value) in json {
//
//                let category = BoardCategoryModel()
//                category.name = key
//                result?.append(category)
//
//                if let valueData = self.toJson(any: value) {
//                    if let boards = BoardModel.parseArray(from: valueData) {
//                        category.boards = boards
//                    }
//                }
//
//            }
//        }
//
//        return result
//    }
    
  
  
  
}
