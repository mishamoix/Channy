//
//  ThreadRepledService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ThreadRepledService: ThreadReplyService {
    
    private let replyedPost: PostModel
    
    override var name: String { return self.replyedPost.comment }
    
    
    init(thread: ThreadModel, parent: PostModel, posts: [PostModel], replyed: PostModel) {
        self.replyedPost = replyed
        
        super.init(thread: thread, parent: parent, posts: posts)
    }
    
    
    
    override func load() -> Observable<ResultType> {
        let result = ResultThreadModel<DataType>(result: self.posts, type: .replyed(post: self.replyedPost))
        return Observable<ResultType>.just(result)
    }
    

}
