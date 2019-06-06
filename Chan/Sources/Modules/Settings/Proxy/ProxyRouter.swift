//
//  ProxyRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ProxyInteractable: Interactable {
    var router: ProxyRouting? { get set }
    var listener: ProxyListener? { get set }
}

protocol ProxyViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProxyRouter: ViewableRouter<ProxyInteractable, ProxyViewControllable>, ProxyRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProxyInteractable, viewController: ProxyViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
