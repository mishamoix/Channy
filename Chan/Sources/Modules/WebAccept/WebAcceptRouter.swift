//
//  WebAcceptRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol WebAcceptInteractable: Interactable {
    var router: WebAcceptRouting? { get set }
    var listener: WebAcceptListener? { get set }
}

protocol WebAcceptViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WebAcceptRouter: ViewableRouter<WebAcceptInteractable, WebAcceptViewControllable>, WebAcceptRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WebAcceptInteractable, viewController: WebAcceptViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
