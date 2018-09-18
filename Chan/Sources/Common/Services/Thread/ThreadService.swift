//
//  ThreadService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift


protocol ThreadServiceProtocol: BaseServiceProtocol {
    
    typealias ResultType = ResultThreadModel<DataType>
    typealias DataType = [PostModel]

    var thread: ThreadModel { get }
    var publish: PublishSubject<ResultType>? { get set }

    func load()
    
    var name: String { get }
}

class ThreadService: BaseService, ThreadServiceProtocol {
    
    let thread: ThreadModel
    var publish: PublishSubject<ResultType>? = nil
    
    private let provider = ChanProvider<ThreadTarget>()
    
    var name: String { return self.thread.posts.first?.comment ?? "" }
    
    init(thread: ThreadModel) {
        self.thread = thread
    }
    
    func load() {
        self.provider
            .rx
            .request(.load(board: self.thread.board?.uid ?? "", idx: self.thread.uid))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                if let res = self?.makeModel(data: response.data) {
                    let result = ResultThreadModel<DataType>(result: res, type: .all)
                    self?.publish?.on(.next(result))
                }

            }, onError: { [weak self] error in
//                self?.publish.
            }).disposed(by: self.disposeBag)
    }
    
    private func makeModel(data: Data) -> DataType {
        
        var result: DataType = []
        if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? Dictionary<String, Any> {
            
            
            if let threads = json["threads"] as? [Any], let postsArray = threads.first as? [String:Any], let posts = postsArray["posts"] as? [[String:AnyObject]] {
                if let valueData = try? JSONSerialization.data(withJSONObject: posts, options: .prettyPrinted) {
                    if let res = PostModel.parseArray(from: valueData) {
                        result = res
                    }
                }
            }
        }
        
        return result
        
    }

    
    
}
