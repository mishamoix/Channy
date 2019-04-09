//
//  RootInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func setupMainViews()
    func setupOnboard()
    func openMenu()
    func closeMenu()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        self.router?.setupMainViews()
//        self.router?.setupOnboard()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    
    // MARK: BoardsListListener
    func open(board: BoardModel) {
        
    }
    func closeBoardsList() {
        
    }
    
    // MARK: MainContainerListner
    func openMenu() {
        self.router?.openMenu()
    }
    
    func closeMenu() {
        self.router?.closeMenu()
    }
}
