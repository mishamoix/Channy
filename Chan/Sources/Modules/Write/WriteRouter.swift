//
//  WriteRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol WriteInteractable: Interactable {
    var router: WriteRouting? { get set }
    var listener: WriteListener? { get set }
}

protocol WriteViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WriteRouter: ViewableRouter<WriteInteractable, WriteViewControllable>, WriteRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WriteInteractable, viewController: WriteViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    // MARK: WriteRouting
    func close() {
        self.viewController.pop()
    }

}
