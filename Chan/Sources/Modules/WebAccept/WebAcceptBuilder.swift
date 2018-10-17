//
//  WebAcceptBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol WebAcceptDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WebAcceptComponent: Component<WebAcceptDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol WebAcceptBuildable: Buildable {
    func build(withListener listener: WebAcceptListener, model: WebAcceptViewModel) -> WebAcceptRouting
}

final class WebAcceptBuilder: Builder<WebAcceptDependency>, WebAcceptBuildable {

    override init(dependency: WebAcceptDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WebAcceptListener, model: WebAcceptViewModel) -> WebAcceptRouting {
        let component = WebAcceptComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "WebAcceptViewController", bundle: nil).instantiateViewController(withIdentifier: "WebAcceptViewController") as! WebAcceptViewController
        let interactor = WebAcceptInteractor(presenter: viewController, model: model)
        interactor.listener = listener
        return WebAcceptRouter(interactor: interactor, viewController: viewController)
    }
}
