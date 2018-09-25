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
    func loadAllBoards()
    
    var publish: PublishSubject<ResultType>? { get set }
}

class BoardsListService: BaseService, BoardsListServiceProtocol {
      
    var publish: PublishSubject<ResultType>? = nil
    private let provider = ChanProvider<BoardsListTarget>()
    
    override init() {
        super.init()
    }
    
    func loadAllBoards() {
        
        
        if let publish = self.publish {
        self.provider.rx
            .request(.list)
            .asObservable()
            .retry(RetryCount)
            .flatMap {[weak self] (response) -> Observable<ResultType> in
                let res = self?.makeModels(data: response.data)
                return Observable<ResultType>.just(res)
            }.bind(to: publish).disposed(by: self.disposeBag)
        }
//            .subscribe(onSuccess: { [weak self] response  in
//                let res = self?.makeModels(data: response.data)
//                self?.publish?.on(.next(res))
//            }) { [weak self] error in
//                if let err = self?.handleError(err: error) {
//                    self?.publish?.on(.error(err))
//                }
//            }.disposed(by: self.disposeBag)
    }
    
    func makeModels(data: Data) -> ResultType {
        var result: ResultType = []
        
        if let json = self.fromJson(data: data) {
            for (key, value) in json {
                
                let category = BoardCategoryModel()
                category.name = key
                result?.append(category)
                
//                let valueData = NSKeyedArchiver.archivedData(withRootObject: value)
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
