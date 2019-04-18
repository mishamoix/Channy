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
    
    typealias DataType = [PostModel]
    typealias ResultType = ResultThreadModel<DataType>

    var thread: ThreadModel { get }
//    var publish: PublishSubject<ResultType>? { get set }

    func load() -> Observable<ResultType>
    
    var name: String { get }
}

class ThreadService: BaseService, ThreadServiceProtocol {
    
    let thread: ThreadModel
//    var publish: PublishSubject<ResultType>? = nil
    
    private let provider = ChanProvider<ThreadTarget>()
    
    var name: String { return self.internalName ?? "" }
    var internalName: String? = nil
    
    init(thread: ThreadModel) {
        self.thread = thread
        super.init()
        
//        self.updateInternalName(thread.posts)
    }
    
    func load() -> Observable<ResultType> {
        guard let board = self.thread.board, let imageboard = board.imageboard else {
            return Observable<ResultType>.error(ChanError.badRequest)
        }
        
        
        return self.provider
            .rx
            .request(.load(imageboard: imageboard.id, board: board.id, idx: self.thread.id))
            .asObservable()
            .flatMap({ [weak self] response -> Observable<ResultType> in
                if let res = self?.makeModel(data: response.data) {
                    let result = ResultThreadModel<DataType>(result: res, type: .all)
                    return Observable<ResultType>.just(result)
                } else {
                    return Observable<ResultType>.error(ChanError.parseError)
                }
            })
    }
    
    private func makeModel(data: Data) -> DataType {
        
        var result: DataType = []
//        if let json = self.fromJson(data: data) {
        
            
//            if let threads = json["threads"] as? [Any], let postsArray = threads.first as? [String:Any], let posts = postsArray["posts"] as? [[String:AnyObject]] {
//                if let valueData = self.toJson(array: posts) {
            if let res = PostModel.parseArray(from: data) {
                result = res
            }
//                }
//            }
//        }
        
        return result
        
    }

    private func updateInternalName(_ posts: [PostModel]) {
        if let post = posts.first {
            self.internalName = post.comment
        }
    }
  
    override func cancel() {
        super.cancel()
    }
    
    
}
