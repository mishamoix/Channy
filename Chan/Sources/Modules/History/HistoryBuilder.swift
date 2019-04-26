//
//  HistoryBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol HistoryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class HistoryComponent: Component<HistoryDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol HistoryBuildable: Buildable {
    func build(withListener listener: HistoryListener) -> HistoryRouting
}

final class HistoryBuilder: Builder<HistoryDependency>, HistoryBuildable {

    override init(dependency: HistoryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HistoryListener) -> HistoryRouting {
        let component = HistoryComponent(dependency: dependency)
        let viewController = HistoryViewController()
        let interactor = HistoryInteractor(presenter: viewController)
        interactor.listener = listener
        return HistoryRouter(interactor: interactor, viewController: viewController)
    }
}
