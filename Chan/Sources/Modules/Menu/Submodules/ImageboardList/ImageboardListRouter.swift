//
//  ImageboardListRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ImageboardListInteractable: Interactable {
    var router: ImageboardListRouting? { get set }
    var listener: ImageboardListListener? { get set }
}

protocol ImageboardListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ImageboardListRouter: ViewableRouter<ImageboardListInteractable, ImageboardListViewControllable>, ImageboardListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ImageboardListInteractable, viewController: ImageboardListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
