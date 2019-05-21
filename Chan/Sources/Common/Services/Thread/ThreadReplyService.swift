//
//  ThreadReplyService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ThreadReplyService: ThreadService {
    
    private let reply: PostReplysViewModel
    
    var posts: [PostModel] {
        return self.thread.posts
    }
    
    init(reply: PostReplysViewModel) {
        self.reply = reply
        super.init(thread: reply.thread)
    }
    
    
    override func load() -> Observable<ThreadReplyService.ResultType> {
        switch self.reply.type {
        case .replies: do {
            let uids = self.reply.parent.selfReplies
            let posts = self.posts.filter({ uids.contains($0.uid) })
            
            let copyThread = self.thread.copy() as! ThreadModel
            copyThread.subject = self.reply.parent.comment
            copyThread.posts = posts
            
            let result = ResultThreadModel<ThreadReplyService.DataType>(result: copyThread, type: .all)
            return Observable<ThreadReplyService.ResultType>.just(result)
        }
            
        case .reply:
            let copyThread = self.thread.copy() as! ThreadModel
            copyThread.posts = [self.reply.parent]

            let result = ResultThreadModel<ThreadReplyService.DataType>(result: copyThread, type: .all)
            return Observable<ThreadReplyService.ResultType>.just(result)
        }
    }
    
//    var disposeBag: DisposeBag = DisposeBag()
//
//    let thread: ThreadModel
//    private let parent: PostModel
//    let posts: [PostModel]
//
////    var publish: PublishSubject<ResultType>? = nil
//
////    private let provider = ChanProvider<ThreadTarget>()
//
//    var name: String { return self.parent.uid }
//
//
//    init(thread: ThreadModel, parent: PostModel, posts: [PostModel]) {
//        self.thread = thread
//        self.parent = parent
//        self.posts = posts
//    }
//
//    func load() -> Observable<ResultType> {
//        return Observable<ResultType>.error(ChanError.notFound)
////        let result = ResultThreadModel<DataType>(result: self.posts, type: .replys(parent: self.parent))
////        return Observable<ResultType>.just(result)
//    }
//
//
//    func cancel() {
//
//    }
//
}
