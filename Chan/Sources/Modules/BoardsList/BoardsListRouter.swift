//
//  BoardsListRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardsListInteractable: Interactable, BoardListener {
    var router: BoardsListRouting? { get set }
    var listener: BoardsListListener? { get set }
}

protocol BoardsListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardsListRouter: ViewableRouter<BoardsListInteractable, BoardsListViewControllable>, BoardsListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: BoardsListInteractable, viewController: BoardsListViewControllable, board: BoardBuildable) {
        self.boardBuildable = board
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Private
    private let boardBuildable: BoardBuildable
    private weak var board: ViewableRouting?
    
    func openBoard(with board: BoardModel) {
        if self.canDeattach(router: self.board) {
            let board = self.boardBuildable.build(withListener: self.interactor, board: board)
            self.attachChild(board)
            self.board = board
            
            self.viewController.push(view: board.viewControllable)
        }
    }
}
