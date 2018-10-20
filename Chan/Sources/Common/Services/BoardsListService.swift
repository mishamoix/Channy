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
    typealias ResultType = [BoardCategoryModel]?
    func loadAllBoards() -> Observable<ResultType>
    func dropCache()
    
    
}

class BoardsListService: BaseService, BoardsListServiceProtocol {
      
    private let provider = ChanProvider<BoardsListTarget>()
    
    private var cachedResult: [BoardCategoryModel]? = nil
    
    override init() {
        super.init()
    }
    
    func loadAllBoards() -> Observable<ResultType> {
        
        if self.cachedResult == nil {
            return self.load()
        } else {
            return self.getCachedBoards()
        }

    }
    
    func dropCache() {
        self.cachedResult = nil
    }
    
    private func getCachedBoards() -> Observable<ResultType> {
        return Observable<ResultType>.just(self.cachedResult)
    }
    
    private func load() -> Observable<ResultType> {
        return self.provider
            .rx
            .request(.list)
            .asObservable()
            .retry(RetryCount)
            .flatMap {[weak self] (response) -> Observable<ResultType> in
                let res = self?.makeModels(data: response.data)
                self?.cachedResult = res
                return Observable<ResultType>.just(res)
        }

    }
    
    private func makeModels(data: Data) -> ResultType {
        var result: ResultType = []
        
        if let json = self.fromJson(data: data) {
            for (key, value) in json {
                
                let category = BoardCategoryModel()
                category.name = key
                result?.append(category)
                
                if let valueData = self.toJson(any: value) {
                    if let boards = BoardModel.parseArray(from: valueData) {
                        category.boards = boards
                    }
                }
                
            }
        }
        
        return result
    }
    
  
  
  
}
