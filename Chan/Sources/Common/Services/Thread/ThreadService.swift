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
    
    typealias DataType = ThreadModel
    typealias ResultType = ResultThreadModel<DataType>

//    var thread: ThreadModel { get }
//    var publish: PublishSubject<ResultType>? { get set }

    func load() -> Observable<ResultType>
    
    var name: String { get }
}

class ThreadService: BaseService, ThreadServiceProtocol {
    
    var thread: ThreadModel
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
                    self?.updateThread(thread: res)
                    let result = ResultThreadModel<DataType>(result: res, type: .all)
                    return Observable<ResultType>.just(result)
                } else {
                    return Observable<ResultType>.error(ChanError.parseError)
                }
            })
    }
    
    private func makeModel(data: Data) -> DataType? {
        
        var result: DataType? = nil
        if let dict = self.fromJson(data: data) {
        
            
            if let posts = dict["posts"] as? [Any], let threadDict = dict["thread"] {
                
                if let postsData = self.toJson(array: posts), let threadData = self.toJson(any: threadDict) {
                    
                    if let thread = ThreadModel.parse(from: threadData), let postsArray = PostModel.parseArray(from: postsData) {
                        
                        var idx = 0
                        
                        thread.posts = postsArray.map({ (model) -> PostModel in
                            idx += 1
                            model.number = idx
                            return model
                        })
                        
                        result = thread
                        
                        thread.board = self.thread.board
                        self.thread = thread
                    }
                }
            }
        }
        
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
    
    
    private func updateThread(thread: ThreadModel) {
        if let dbThread = self.coreData.findModel(with: CoreDataThread.self, predicate: NSPredicate(format: "id = \"\(thread.id)\"")) as? ThreadModel {
            thread.type = dbThread.type
        }
    }
    
    
}
