//
//  BoardRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardInteractable: Interactable, ThreadListener, BoardsListListener, WebAcceptListener, WriteListener {
    var router: BoardRouting? { get set }
    var listener: BoardListener? { get set }
}

protocol BoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardRouter: ViewableRouter<BoardInteractable, BoardViewControllable>, BoardRouting {
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: BoardInteractable, viewController: BoardViewControllable, thread: ThreadBuildable,  agreement: WebAcceptBuildable, createThread: WriteBuildable) {
        
        self.threadBuildable = thread
        self.agreementBuildable = agreement
        self.createThreadBuildable = createThread
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    // MARK: BoardRouting
    func open(thread: ThreadModel) {
        if self.canDeattach(router: self.thread) {

            self.thread = nil
            
            let threadModule = self.threadBuildable.build(withListener: self.interactor, thread: thread)
            self.attachChild(threadModule)
            self.thread = threadModule

            
            self.viewControllable.push(view: threadModule.viewControllable)
        }
    }
    
    
    func openAgreement(model: WebAcceptViewModel) {
        self.closeAgreement()
        self.tryDeattach(router: self.agreement) {
            let agreement = self.agreementBuildable.build(withListener: self.interactor, model: model)
            self.agreement = agreement
            self.attachChild(agreement)

            self.viewController.present(view: agreement.viewControllable)
        }
    }

    func closeAgreement() {
        self.agreement?.viewControllable.dismiss()
        self.tryDeattach(router: self.agreement) {
            self.agreement = nil
        }
    }

    func openCreateThread(_ thread: ThreadModel) {
        if let createThread = self.createThread {
            self.viewController.push(view: createThread.viewControllable)
        } else {
            let createThread = createThreadBuildable.build(withListener: self.interactor, thread: thread, data: nil)
            self.attachChild(createThread)
            self.createThread = createThread
            self.viewController.push(view: createThread.viewControllable)

        }
    }
    
    func closeCreateThread() {
        
        if let createThread = self.createThread {
            createThread.viewControllable.pop()
        }
        
        self.tryDeattach(router: self.createThread) {}
    }

    
    // MARK: Private
    private let threadBuildable: ThreadBuildable
    private weak var thread: ViewableRouting?
    
//    private let boardListBuildable: BoardsListBuildable
//    private weak var boardList: ViewableRouting?
    
    private let agreementBuildable: WebAcceptBuildable
    private weak var agreement: ViewableRouting?
    
    private let createThreadBuildable: WriteBuildable
    private weak var createThread: ViewableRouting?
    

    
}
