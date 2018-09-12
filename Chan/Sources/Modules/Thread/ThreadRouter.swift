//
//  ThreadRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ThreadInteractable: Interactable {
    var router: ThreadRouting? { get set }
    var listener: ThreadListener? { get set }
}

protocol ThreadViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadRouter: ViewableRouter<ThreadInteractable, ThreadViewControllable>, ThreadRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ThreadInteractable, viewController: ThreadViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
