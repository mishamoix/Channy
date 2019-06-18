//
//  OnboardRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol OnboardInteractable: Interactable, WebAcceptListener {
    var router: OnboardRouting? { get set }
    var listener: OnboardListener? { get set }
}

protocol OnboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OnboardRouter: ViewableRouter<OnboardInteractable, OnboardViewControllable>, OnboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: OnboardInteractable, viewController: OnboardViewControllable, webView: WebAcceptBuildable) {
        self.webAcceptBuilder = webView
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    private let webAcceptBuilder: WebAcceptBuildable
    private weak var webAccept: ViewableRouting?
    
    func openWebView(model: WebAcceptViewModel) {
        self.tryDeattach(router: self.webAccept) {
            let agreement = self.webAcceptBuilder.build(withListener: self.interactor, model: model)
            self.webAccept = agreement
            self.attachChild(agreement)
            
            self.viewController.present(view: agreement.viewControllable)
        }
    }
    
    func closeWebView() {
        self.webAccept?.viewControllable.dismiss()
        self.tryDeattach(router: self.webAccept) {}
    }

}
