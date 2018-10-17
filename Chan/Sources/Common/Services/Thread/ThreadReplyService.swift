//
//  ThreadReplyService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ThreadReplyService: ThreadServiceProtocol {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let thread: ThreadModel
    private let parent: PostModel
    let posts: [PostModel]
    
//    var publish: PublishSubject<ResultType>? = nil
    
//    private let provider = ChanProvider<ThreadTarget>()
    
    var name: String { return self.parent.uid }

    
    init(thread: ThreadModel, parent: PostModel, posts: [PostModel]) {
        self.thread = thread
        self.parent = parent
        self.posts = posts
    }
    
    func load() -> Observable<ResultType> {
        let result = ResultThreadModel<DataType>(result: self.posts, type: .replys(parent: self.parent))
        return Observable<ResultType>.just(result)
    }
    
    
    func cancel() {
        
    }

}
