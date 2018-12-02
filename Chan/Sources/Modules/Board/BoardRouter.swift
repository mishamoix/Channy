//
//  BoardRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardInteractable: Interactable, ThreadListener, BoardsListListener, WebAcceptListener {
    var router: BoardRouting? { get set }
    var listener: BoardListener? { get set }
}

protocol BoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardRouter: ViewableRouter<BoardInteractable, BoardViewControllable>, BoardRouting {
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: BoardInteractable, viewController: BoardViewControllable, thread: ThreadBuildable, boardList: BoardsListBuildable, agreement: WebAcceptBuildable) {
        
        self.threadBuildable = thread
        self.boardListBuildable = boardList
        self.agreementBuildable = agreement
        
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
    
    func openBoardList() {
        if self.canDeattach(router: self.boardList) {
            
            self.boardList = nil
            
            let boardList = self.boardListBuildable.build(withListener: self.interactor)
            self.attachChild(boardList)
            self.boardList = boardList
            
            let nav = BaseNavigationController(rootViewController: boardList.viewControllable.uiviewController)
            nav.disableSwipe = true
            self.viewController.present(vc: nav)
        }
    }
    
    func closeBoardsList() {
        self.boardList?.viewControllable.uiviewController.navigationController?.dismiss(animated: true, completion: nil)
        self.tryDeattach(router: self.boardList) {
            self.boardList = nil
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
    //
    
    // MARK: Private
    private let threadBuildable: ThreadBuildable
    private weak var thread: ViewableRouting?
    
    private let boardListBuildable: BoardsListBuildable
    private weak var boardList: ViewableRouting?
    
    
    private let agreementBuildable: WebAcceptBuildable
    private weak var agreement: ViewableRouting?
    
}
