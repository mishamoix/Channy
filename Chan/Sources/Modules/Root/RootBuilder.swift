//
//  RootBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency>, MainContainerDependency, OnboardDependency, MenuDependency {
    var threadIsRoot: Bool {
        return true
    }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }

  func build() -> LaunchRouting {
    let component = RootComponent(dependency: dependency)
    let viewController = RootViewController()
        
//    let listService = BoardsListService()
    let interactor = RootInteractor(presenter: viewController)
    
    let mainContainer = MainContainerBuilder(dependency: component)
    let onboard = OnboardBuilder(dependency: component)
    
    let menu = MenuBuilder(dependency: component)
    
    return RootRouter(interactor: interactor, viewController: viewController, mainContainer: mainContainer, onboard: onboard, menu: menu)
  }
}
