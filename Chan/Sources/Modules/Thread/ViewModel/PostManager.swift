//
//  PostManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostManager {
    
    private let posts: [PostModel]
    private let thread: ThreadModel
    
    private(set) var postsVM: [PostViewModel] = []
    
    init(posts: [PostModel], thread: ThreadModel) {
        self.posts = posts
        self.thread = thread
        
        self.process()
    }
    
    func addFilter(by parentUid: String) {
        if let parent = self.postsVM.filter({ $0.uid == parentUid }).first {
            self.postsVM = self.postsVM.filter { parent.replyPosts.contains($0.uid) }
        }
    }
    
    private func process() {
        let postsVM = self.posts.compactMap { PostViewModel(model: $0, thread: thread.uid) }
        self.postsVM = postsVM
        
        var replyedDict: [String:[String]] = [:]
        for post in postsVM {
            for reply in post.modifier.replyedPosts {
                if let replyedPostUID = reply.post {
                    if replyedDict[replyedPostUID] == nil {
                        replyedDict[replyedPostUID] = []
                    }
                    
                    replyedDict[replyedPostUID]?.append(post.uid)
                }
            }
        }
        
        for (key, val) in replyedDict {
            self.findPostVm(uid: key)?.replyPosts = val
        }
    }
    
    private func findPostVm(uid: String) -> PostViewModel? {
        return self.postsVM.filter({ $0.uid == uid }).first
    }
}
