//
//  MainContainerRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MainContainerInteractable: Interactable, BoardListener, FavoritesListener, HistoryListener {
    var router: MainContainerRouting? { get set }
    var listener: MainContainerListener? { get set }
}

protocol MainContainerViewControllable: ViewControllable {
    func addTabs(views: [UIViewController])
}

final class MainContainerRouter: ViewableRouter<MainContainerInteractable, MainContainerViewControllable>, MainContainerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainContainerInteractable, viewController: MainContainerViewControllable, board: BoardBuildable, favorites: FavoritesBuildable, history: HistoryBuildable) {
        
        self.boardBuilder = board
        self.favoritesBuilder = favorites
        self.historyBuilder = history

        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Private
    private let boardBuilder: BoardBuildable
    private weak var board: ViewableRouting?
    
    private let favoritesBuilder: FavoritesBuildable
    private weak var favorites: ViewableRouting?

    private let historyBuilder: HistoryBuildable
    private weak var history: ViewableRouting?



    
    // MARK: MainContainerRouting
    func setupViews() {
        
        var result: [UIViewController] = []
        
        if self.canDeattach(router: self.board) {
            let board = self.boardBuilder.build(withListener: self.interactor)
            self.board = board
            self.attachChild(board)
            
            let nc = BaseNavigationController(rootViewController: board.viewControllable.uiviewController)
            
            nc.tabBarItem = UITabBarItem(title: "Доска", image: .boards, tag: 0)
            
            result.append(nc)
        }
        
        
        if self.canDeattach(router: self.favorites) {
            let favorites = self.favoritesBuilder.build(withListener: self.interactor)
            self.favorites = favorites
            self.attachChild(favorites)
            
            let vc = favorites.viewControllable.uiviewController
            
            vc.tabBarItem = UITabBarItem(title: "Избранное", image: .favorites, tag: 1)
            
            result.append(vc)
        }
        
        if self.canDeattach(router: self.history) {
            let history = self.historyBuilder.build(withListener: self.interactor)
            self.history = history
            self.attachChild(history)
            
            let vc = history.viewControllable.uiviewController
            
            vc.tabBarItem = UITabBarItem(title: "История", image: .history, tag: 2)
            
            result.append(vc)
        }
        
        self.viewController.addTabs(views: result)
    }
}
