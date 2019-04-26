//
//  FavoritesRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol FavoritesInteractable: Interactable {
    var router: FavoritesRouting? { get set }
    var listener: FavoritesListener? { get set }
}

protocol FavoritesViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FavoritesRouter: ViewableRouter<FavoritesInteractable, FavoritesViewControllable>, FavoritesRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FavoritesInteractable, viewController: FavoritesViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
