//
//  OnboardInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol OnboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OnboardPresentable: Presentable {
    var listener: OnboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol OnboardListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class OnboardInteractor: PresentableInteractor<OnboardPresentable>, OnboardInteractable, OnboardPresentableListener {

    weak var router: OnboardRouting?
    weak var listener: OnboardListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OnboardPresentable) {
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
