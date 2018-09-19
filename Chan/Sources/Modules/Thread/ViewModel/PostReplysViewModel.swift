//
//  PostReplysViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostReplysViewModel {
    let posts: [PostModel]
    let parent: PostModel
    let thread: ThreadModel
    let cachedVM: [PostViewModel]?
    let replyed: PostModel?
    
    init(parent: PostModel, posts: [PostModel], thread: ThreadModel, replyed: PostModel? = nil, cachedVM: [PostViewModel]? = nil) {
        self.posts = posts
        self.parent = parent
        self.thread = thread
        self.cachedVM = cachedVM
        self.replyed = replyed
    }
}
