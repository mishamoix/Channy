//
//  HistoryInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol HistoryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HistoryPresentable: Presentable {
    var listener: HistoryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol HistoryListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HistoryInteractor: PresentableInteractor<HistoryPresentable>, HistoryInteractable, HistoryPresentableListener {

    weak var router: HistoryRouting?
    weak var listener: HistoryListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: HistoryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let history = HistoryService()
        let _ = history.read()
        
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
