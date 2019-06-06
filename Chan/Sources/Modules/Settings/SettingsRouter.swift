//
//  SettingsRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol SettingsInteractable: Interactable, ProxyListener {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>, SettingsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: SettingsInteractable, viewController: SettingsViewControllable, proxyBuilable: ProxyBuildable) {
        self.proxyBuilable = proxyBuilable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    private let proxyBuilable: ProxyBuildable
    private var proxy: ViewableRouting?
    
    func openProxy() {
        if self.canDeattach(router: self.proxy) {
            let proxy = self.proxyBuilable.build(withListener: self.interactor)
            self.proxy = proxy
            
            self.viewController.push(view: proxy.viewControllable, animated: true)
        }
    }
}
