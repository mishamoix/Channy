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
    
    func addBoards()
    func addFavorites() -> MarkedInputProtocol?
    func addHistory() -> MarkedInputProtocol?
}

protocol MainContainerPresentable: Presentable {
    var listener: MainContainerPresentableListener? { get set }

    func openBoards()
}

protocol MainContainerListener: class {
    func openMenu()
    func closeMenu()
}

final class MainContainerInteractor: PresentableInteractor<MainContainerPresentable>, MainContainerInteractable, MainContainerPresentableListener {
    

    weak var router: MainContainerRouting?
    weak var listener: MainContainerListener?
    
    let boardInput: BoardInputProtocol
    weak var favoriteInput: MarkedInputProtocol?
    weak var historyInput: MarkedInputProtocol?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MainContainerPresentable, boardInput: BoardInputProtocol) {
        self.boardInput = boardInput
        super.init(presenter: presenter)
        presenter.listener = self
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()

//        self.router?.setupViews()
        
        self.router?.addBoards()
        self.favoriteInput = self.router?.addFavorites()
        self.historyInput = self.router?.addHistory()
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
    
    func closeMenu() {
        self.listener?.closeMenu()
    }
    
    // MARK: MarkedListener
    func open(thread: ThreadModel) {
        self.presenter.openBoards()
        Helper.performOnMainThread {
            self.boardInput.open(thread: thread)
        }
    }
    
    // MARK: MainContainerPresentableListener
    func tabbarWillChange() {
        self.boardInput.deactivateSearch()
    }
    
    func scrollToTop(idx: Int) {
        if idx == 0 {
            self.boardInput.scrollToTop()
        } else if idx == 1 {
            self.favoriteInput?.scrollToTop()
        } else if idx == 2 {
            self.historyInput?.scrollToTop()
        }
    }
    

}
