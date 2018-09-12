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

protocol BoardsListServiceProtocol {
    typealias ResultType = [BoardCategoryModel]?
    func loadAllBoards()
    
    var publish: PublishSubject<ResultType>? { get set }
}

class BoardsListService: BaseService, BoardsListServiceProtocol {
  
    private let disposeBag = DisposeBag()
    
    var publish: PublishSubject<ResultType>? = nil
    private let provider = ChanProvider<BoardsListTarget>()
    
    override init() {
        super.init()
    }
    
    func loadAllBoards() {
        
        self.provider.rx.request(.list).subscribe(onSuccess: {[weak self] response  in
            let res = self?.makeModels(data: response.data)
            self?.publish?.on(.next(res))
        }) { [weak self] error in
            self?.publish?.on(.error(error))
        }.disposed(by: self.disposeBag)
    }
    
    func makeModels(data: Data) -> ResultType {
        var result: ResultType = []
        
        if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? Dictionary<String, Any> {
            for (key, value) in json {
                
                let category = BoardCategoryModel()
                category.name = key
                result?.append(category)
                
//                let valueData = NSKeyedArchiver.archivedData(withRootObject: value)
                if let valueData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    if let boards = BoardModel.parseArray(from: valueData) {
                        category.boards = boards
                    }
                }
                
            }
        }
        
        return result
    }
    
  
  
  
}
