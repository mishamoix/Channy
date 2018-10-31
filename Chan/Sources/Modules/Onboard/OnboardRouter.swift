//
//  OnboardRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol OnboardInteractable: Interactable {
    var router: OnboardRouting? { get set }
    var listener: OnboardListener? { get set }
}

protocol OnboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OnboardRouter: ViewableRouter<OnboardInteractable, OnboardViewControllable>, OnboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OnboardInteractable, viewController: OnboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
