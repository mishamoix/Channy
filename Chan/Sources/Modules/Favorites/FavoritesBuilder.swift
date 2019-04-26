//
//  FavoritesBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol FavoritesDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FavoritesComponent: Component<FavoritesDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FavoritesBuildable: Buildable {
    func build(withListener listener: FavoritesListener) -> FavoritesRouting
}

final class FavoritesBuilder: Builder<FavoritesDependency>, FavoritesBuildable {

    override init(dependency: FavoritesDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FavoritesListener) -> FavoritesRouting {
        let component = FavoritesComponent(dependency: dependency)
        let viewController = FavoritesViewController()
        let interactor = FavoritesInteractor(presenter: viewController)
        interactor.listener = listener
        return FavoritesRouter(interactor: interactor, viewController: viewController)
    }
}
