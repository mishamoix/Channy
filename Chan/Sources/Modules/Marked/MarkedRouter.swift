//
//  MarkedRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MarkedInteractable: Interactable, MarkedInputProtocol {
    var router: MarkedRouting? { get set }
    var listener: MarkedListener? { get set }
}

protocol MarkedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MarkedRouter: ViewableRouter<MarkedInteractable, MarkedViewControllable>, MarkedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MarkedInteractable, viewController: MarkedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
}
