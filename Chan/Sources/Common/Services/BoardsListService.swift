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
    
    var publish: PublishSubject<ResultType>? { get set }
}

class BoardsListService: BaseService, BoardsListServiceProtocol {
      
    var publish: PublishSubject<ResultType>? = nil
    private let provider = ChanProvider<BoardsListTarget>()
    
    override init() {
        super.init()
    }
    
    func loadAllBoards() -> Observable<ResultType> {
        
        return self.provider.rx
            .request(.list)
            .asObservable()
            .retry(RetryCount)
            .flatMap {[weak self] (response) -> Observable<ResultType> in
                let res = self?.makeModels(data: response.data)
                return Observable<ResultType>.just(res)
            }

    }
    
    func makeModels(data: Data) -> ResultType {
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
