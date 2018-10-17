//
//  ThreadRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ThreadInteractable: Interactable, ThreadListener {
    var router: ThreadRouting? { get set }
    var listener: ThreadListener? { get set }
}

protocol ThreadViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadRouter: ViewableRouter<ThreadInteractable, ThreadViewControllable>, ThreadRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: ThreadInteractable, viewController: ThreadViewControllable, threadBuilder: ThreadBuildable) {
        self.threadBuilder = threadBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: ThreadRouting
    func openThread(with post: PostReplysViewModel) {
        if self.canDeattach(router: self.thread) {
            let thread = self.threadBuilder.build(withListener: self.interactor, replys: post)
            self.thread = thread
            self.attachChild(thread)
            self.viewController.push(view: thread.viewControllable)
        }
    }
    
    func openNewThread(with thread: ThreadModel) {
        if self.canDeattach(router: self.thread) {
            let thread = self.threadBuilder.build(withListener: self.interactor, thread: thread)
            self.thread = thread
            self.attachChild(thread)
            self.viewController.push(view: thread.viewControllable)
        }
    }
    
    func popToCurrent() {
        self.viewControllable.pop(animated: true, view: self.viewControllable)
    }
    
    func showMediaViewer(_ vc: UIViewController) {
//        self.viewController.uiviewController.present(vc, animated: true, completion: nil)
        self.viewController.uiviewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Private
    private let threadBuilder: ThreadBuildable
    private weak var thread: ViewableRouting?
    
    
}
