//
//  MainContainerRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MainContainerInteractable: Interactable, BoardListener, MarkedListener {
    var router: MainContainerRouting? { get set }
    var listener: MainContainerListener? { get set }
}

protocol MainContainerViewControllable: ViewControllable {
    func addTab(view: UIViewController)
}

final class MainContainerRouter: ViewableRouter<MainContainerInteractable, MainContainerViewControllable>, MainContainerRouting {
    
//    weak var favoriteInput: MarkedInputProtocol?
//    weak var historyInput: MarkedInputProtocol?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainContainerInteractable, viewController: MainContainerViewControllable, board: BoardBuildable, favorites: MarkedBuildable, history: MarkedBuildable) {
        
        self.boardBuilder = board
        self.favoritesBuilder = favorites
        self.historyBuilder = history

        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Private
    private let boardBuilder: BoardBuildable
    private weak var board: ViewableRouting?
    
    private let favoritesBuilder: MarkedBuildable
    private weak var favorites: ViewableRouting?

    private let historyBuilder: MarkedBuildable
    private weak var history: ViewableRouting?


    
    // MARK: MainContainerRouting
    func setupViews() {
        
        var result: [UIViewController] = []
        
        
        
        
        
//        self.viewController.addTabs(views: result)
        
    }
    
    
    func addBoards() {
        if self.canDeattach(router: self.board) {
            let board = self.boardBuilder.build(withListener: self.interactor)
            self.board = board
            self.attachChild(board)
            
            let nc = BaseNavigationController(rootViewController: board.viewControllable.uiviewController)
            
            nc.tabBarItem = UITabBarItem(title: "Board".localized, image: .boards, tag: 0)
            self.viewController.addTab(view: nc)
            
//            result.append(nc)
        }

    }
    func addFavorites() -> MarkedInputProtocol? {
        if self.canDeattach(router: self.favorites) {
            let favorites = self.favoritesBuilder.buildFavorited(withListener: self.interactor)
            self.favorites = favorites
            self.attachChild(favorites)
            
            let vc = DefaultNavigationController(rootViewController: favorites.viewControllable.uiviewController)
            
            vc.tabBarItem = UITabBarItem(title: "Favorites".localized, image: .favorites, tag: 1)
            
            self.viewController.addTab(view: vc)

            return favorites.interactable as? MarkedInteractable
        }
        
        return nil

    }
    func addHistory() -> MarkedInputProtocol? {
        if self.canDeattach(router: self.history) {
            let history = self.historyBuilder.buildHistory(withListener: self.interactor)
            self.history = history
            self.attachChild(history)
            
            let vc = DefaultNavigationController(rootViewController: history.viewControllable.uiviewController)
            
            vc.tabBarItem = UITabBarItem(title: "History".localized, image: .history, tag: 2)
            
            self.viewController.addTab(view: vc)
            
            return history.interactable as? MarkedInteractable
        }
        
        return nil

    }

    

}
