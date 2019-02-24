//
//  MenuBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MenuDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MenuComponent: Component<MenuDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MenuBuildable: Buildable {
    func build(withListener listener: MenuListener) -> MenuRouting
}

final class MenuBuilder: Builder<MenuDependency>, MenuBuildable {

    override init(dependency: MenuDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MenuListener) -> MenuRouting {
        let component = MenuComponent(dependency: dependency)
        let viewController = MenuViewController()
        let interactor = MenuInteractor(presenter: viewController)
        interactor.listener = listener
        
//        let 
        
        return MenuRouter(interactor: interactor, viewController: viewController)
    }
}
