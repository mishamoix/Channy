//
//  MainContainerRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MainContainerInteractable: Interactable, BoardListener {
    var router: MainContainerRouting? { get set }
    var listener: MainContainerListener? { get set }
}

protocol MainContainerViewControllable: ViewControllable {
    func addTab(view: UIViewController)
}

final class MainContainerRouter: ViewableRouter<MainContainerInteractable, MainContainerViewControllable>, MainContainerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainContainerInteractable, viewController: MainContainerViewControllable, board: BoardBuildable) {
        
        self.boardBuilder = board
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Private
    private let boardBuilder: BoardBuildable
    private weak var board: ViewableRouting?

    
    // MARK: MainContainerRouting
    func setupViews() {
        if self.canDeattach(router: self.board) {
            let board = self.boardBuilder.build(withListener: self.interactor)
            self.board = board
            self.attachChild(board)
            
            let nc = BaseNavigationController(rootViewController: board.viewControllable.uiviewController)
            self.viewController.addTab(view: nc)
        }
    }
}
