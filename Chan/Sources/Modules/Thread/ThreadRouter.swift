//
//  ThreadRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol ThreadInteractable: Interactable, ThreadListener, WriteListener {
    var router: ThreadRouting? { get set }
    var listener: ThreadListener? { get set }
}

protocol ThreadViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadRouter: ViewableRouter<ThreadInteractable, ThreadViewControllable>, ThreadRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: ThreadInteractable, viewController: ThreadViewControllable, threadBuilder: ThreadBuildable, writeBuilder: WriteBuildable? = nil) {
        self.threadBuilder = threadBuilder
        self.writeBuilder = writeBuilder
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
    
    func popToCurrent(animated: Bool) {
        self.viewControllable.pop(animated: animated, view: self.viewControllable)
    }
    
    func closeThread() {
        if let controller = self.self.viewController.uiviewController.navigationController?.viewControllers.last(where: { !$0.isKind(of: ThreadViewController.self) }) {
            self.viewController.uiviewController.navigationController?.popToViewController(controller, animated: true)
        }
    }
    
    func showMediaViewer(_ vc: UIViewController) {
//        self.viewController.uiviewController.present(vc, animated: true, completion: nil)
        self.viewController.uiviewController.present(vc, animated: true, completion: nil)
//        self.viewController.uiviewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWrite(model: ThreadModel, data: Observable<String>) {
        if let writeBuilder = self.writeBuilder {
//            self.tryDeattach(router: self.write) {
            if let write = self.write {
                self.viewController.push(view: write.viewControllable)

            } else {
                let write = writeBuilder.build(withListener: self.interactor, thread: model, data: data)
                self.attachChild(write)
                self.viewController.push(view: write.viewControllable)
                self.write = write
            }
//            }
        }
    }
    
    func closeWrite() {
        if let write = self.write {
            write.viewControllable.pop()
//            write.viewControllable.dismiss(animated: true)
        }
        self.tryDeattach(router: self.write) {}
    }
    
    
    // MARK: Private
    private let threadBuilder: ThreadBuildable
    private weak var thread: ViewableRouting?
    
    private let writeBuilder: WriteBuildable?
    private weak var write: ViewableRouting?

//    WriteBuilder
    
    
}
