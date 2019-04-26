//
//  HistoryRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol HistoryInteractable: Interactable {
    var router: HistoryRouting? { get set }
    var listener: HistoryListener? { get set }
}

protocol HistoryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class HistoryRouter: ViewableRouter<HistoryInteractable, HistoryViewControllable>, HistoryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: HistoryInteractable, viewController: HistoryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
