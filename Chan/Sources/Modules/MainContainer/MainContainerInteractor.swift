//
//  MainContainerInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol MainContainerRouting: ViewableRouting {
    func setupViews()
}

protocol MainContainerPresentable: Presentable {
    var listener: MainContainerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainContainerListener: class {
    func openMenu()
}

final class MainContainerInteractor: PresentableInteractor<MainContainerPresentable>, MainContainerInteractable, MainContainerPresentableListener {

    weak var router: MainContainerRouting?
    weak var listener: MainContainerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainContainerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        self.router?.setupViews()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: BoardListener
    func openMenu() {
        self.listener?.openMenu()
    }
}
