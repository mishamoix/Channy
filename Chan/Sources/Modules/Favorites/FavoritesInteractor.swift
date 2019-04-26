//
//  FavoritesInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol FavoritesRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FavoritesPresentable: Presentable {
    var listener: FavoritesPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FavoritesListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FavoritesInteractor: PresentableInteractor<FavoritesPresentable>, FavoritesInteractable, FavoritesPresentableListener {

    weak var router: FavoritesRouting?
    weak var listener: FavoritesListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FavoritesPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
