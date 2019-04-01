//
//  BoardSelectionBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardSelectionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BoardSelectionComponent: Component<BoardSelectionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BoardSelectionBuildable: Buildable {
    func build(withListener listener: BoardSelectionListener) -> BoardSelectionRouting
}

final class BoardSelectionBuilder: Builder<BoardSelectionDependency>, BoardSelectionBuildable {

    override init(dependency: BoardSelectionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BoardSelectionListener) -> BoardSelectionRouting {
        let component = BoardSelectionComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "BoardSelectionViewController", bundle: nil).instantiateViewController(withIdentifier: "BoardSelectionViewController") as! BoardSelectionViewController
        let interactor = BoardSelectionInteractor(presenter: viewController, service: ImageboardService.instance())
        interactor.listener = listener
        return BoardSelectionRouter(interactor: interactor, viewController: viewController)
    }
}
