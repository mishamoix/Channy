//
//  BoardRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardInteractable: Interactable, ThreadListener {
    var router: BoardRouting? { get set }
    var listener: BoardListener? { get set }
}

protocol BoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardRouter: ViewableRouter<BoardInteractable, BoardViewControllable>, BoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: BoardInteractable, viewController: BoardViewControllable, thread: ThreadBuildable) {
        
        self.threadBuildable = thread
        
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
    
    // MARK: Private
    private let threadBuildable: ThreadBuildable
    private weak var thread: ViewableRouting?
    
}
