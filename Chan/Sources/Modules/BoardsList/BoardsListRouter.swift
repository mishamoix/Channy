//
//  BoardsListRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardsListInteractable: Interactable {
    var router: BoardsListRouting? { get set }
    var listener: BoardsListListener? { get set }
}

protocol BoardsListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardsListRouter: ViewableRouter<BoardsListInteractable, BoardsListViewControllable>, BoardsListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BoardsListInteractable, viewController: BoardsListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
