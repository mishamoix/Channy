//
//  MainContainerBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MainContainerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainContainerComponent: Component<MainContainerDependency>, BoardDependency, MarkedDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainContainerBuildable: Buildable {
    func build(withListener listener: MainContainerListener) -> MainContainerRouting
}

final class MainContainerBuilder: Builder<MainContainerDependency>, MainContainerBuildable {

    override init(dependency: MainContainerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainContainerListener) -> MainContainerRouting {
        let component = MainContainerComponent(dependency: dependency)
        
        let board = BoardBuilder(dependency: component)
        let favorites = MarkedBuilder(dependency: component)
        let history = MarkedBuilder(dependency: component)
        
        let viewController = MainContainerViewController()
        let interactor = MainContainerInteractor(presenter: viewController, boardInput: board.boardInput)
        interactor.listener = listener
        
        return MainContainerRouter(interactor: interactor, viewController: viewController, board: board, favorites: favorites, history: history)
    }
    
    
}
