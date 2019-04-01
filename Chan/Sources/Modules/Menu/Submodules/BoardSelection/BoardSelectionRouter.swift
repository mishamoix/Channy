//
//  BoardSelectionRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardSelectionInteractable: Interactable {
    var router: BoardSelectionRouting? { get set }
    var listener: BoardSelectionListener? { get set }
}

protocol BoardSelectionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardSelectionRouter: ViewableRouter<BoardSelectionInteractable, BoardSelectionViewControllable>, BoardSelectionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BoardSelectionInteractable, viewController: BoardSelectionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
