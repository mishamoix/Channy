//
//  ProxyBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ProxyDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProxyComponent: Component<ProxyDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProxyBuildable: Buildable {
    func build(withListener listener: ProxyListener) -> ProxyRouting
}

final class ProxyBuilder: Builder<ProxyDependency>, ProxyBuildable {

    override init(dependency: ProxyDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProxyListener) -> ProxyRouting {
        let component = ProxyComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "ProxyViewController", bundle: nil).instantiateViewController(withIdentifier: "ProxyViewController") as! ProxyViewController
        
        let service = ProxyService()
        let interactor = ProxyInteractor(presenter: viewController, proxy: service)
        interactor.listener = listener
        return ProxyRouter(interactor: interactor, viewController: viewController)
    }
}
