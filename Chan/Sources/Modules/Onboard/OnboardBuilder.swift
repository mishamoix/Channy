//
//  OnboardBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol OnboardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OnboardComponent: Component<OnboardDependency>, WebAcceptDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OnboardBuildable: Buildable {
    func build(withListener listener: OnboardListener) -> OnboardRouting
}

final class OnboardBuilder: Builder<OnboardDependency>, OnboardBuildable {

    override init(dependency: OnboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OnboardListener) -> OnboardRouting {
        let component = OnboardComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "OnboardViewController", bundle: nil).instantiateViewController(withIdentifier: "OnboardViewController") as! OnboardViewController
        let interactor = OnboardInteractor(presenter: viewController)
        interactor.listener = listener
        
        let webView = WebAcceptBuilder(dependency: component)
        
        return OnboardRouter(interactor: interactor, viewController: viewController, webView: webView)
    }
}
