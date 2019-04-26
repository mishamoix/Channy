//
//  PostManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class CancellationToken {
    var isCancelled = false
}

class PostManager {
    
    var cachedViewModels: [PostViewModel] {
        return self.cachedVM
    }
    
    private var posts: [PostModel] {
        return self.thread?.posts ?? []
    }
    private let thread: ThreadModel?
    
    private var cachedVM: [PostViewModel] = []
    
    init(thread: ThreadModel?) {
        self.thread = thread
    }
    
    
    func process() {
        var result: [PostViewModel] = []
        for (idx, post) in self.posts.enumerated() {
            let vm = PostViewModel(model: post, idx: idx)
            result.append(vm)
//            PostPreparation
        }
        
        self.cachedVM = result
    }
    
    
//    private var isProcessed = false
//
//    private var cancellationToken = CancellationToken()
//
//    var filtredPostsVM: [PostViewModel] {
//        if let parentUid = self.filterParentUid {
//            if let parent = self.internalPostVM.filter({ $0.uid == parentUid }).first {
//                return self.internalPostVM.filter { parent.replyPosts.contains($0.uid) }
//            }
//        }
//
//        if let replyedUid = self.replyedUid, let vm = self.internalPostVM.first(where: { $0.uid == replyedUid }) {
//            return [vm]
//        }
//
//        return self.internalPostVM
//    }
//
//    private(set) var internalPostVM: [PostViewModel] = []
//    private var filterParentUid: String? = nil
//    private var replyedUid: String? = nil
//
//    init(thread: ThreadModel) {
//        self.thread = thread
//    }
//
//    func update(posts: [PostModel]) {
//        self.posts = posts
//        self.cancellationToken = CancellationToken()
//    }
//
//    func update(vms: [PostViewModel]?) {
//        if let vms = vms {
//            self.internalPostVM = vms
//            self.isProcessed = vms.count != 0
//        }
//    }
//
//    func resetFilters() {
//        self.filterParentUid = nil
//    }
//
//    func addFilter(by parentUid: String?) {
//        self.resetFilters()
//        self.filterParentUid = parentUid
//    }
//
//    func onlyReplyed(uid: String?) {
//        self.resetFilters()
//        self.replyedUid = uid
//    }
//
//    func cancel() {
//        self.cancellationToken.isCancelled = true
//    }
//
//    func process() {
//        if self.isProcessed {
//            return
//        }
//
//        var postsVM: [PostViewModel] = []
//        for post in self.posts {
//            if self.cancellationToken.isCancelled {
//                print("Cancelled mapping")
//                return
//            }
//
//            postsVM.append(PostViewModel(model: post, thread: thread.uid))
//        }
////        let postsVM = self.posts.compactMap { PostViewModel(model: $0, thread: thread.uid) }
//        self.internalPostVM = postsVM
//
//        if self.internalPostVM.count != 0 {
//            self.isProcessed = true
//        }
//
//        var replyedDict: [String:[String]] = [:]
//        for post in postsVM {
//            for reply in post.modifier.replyedPosts {
//                if self.cancellationToken.isCancelled {
//                    print("Cancelled mapping")
//                    return
//                }
//
//                if let replyedPostUID = reply.post {
//                    if replyedDict[replyedPostUID] == nil {
//                        replyedDict[replyedPostUID] = []
//                    }
//
//                    replyedDict[replyedPostUID]?.append(post.uid)
//                }
//            }
//        }
//
//        for (key, val) in replyedDict {
//            self.findPostVm(uid: key)?.replyPosts = val
//        }
//    }
//
//    func resetCache() {
//        self.isProcessed = false
//        self.internalPostVM = []
//    }
//
//    private func findPostVm(uid: String) -> PostViewModel? {
//        return self.internalPostVM.filter({ $0.uid == uid }).first
//    }
}
