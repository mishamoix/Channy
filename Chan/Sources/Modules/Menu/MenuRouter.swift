//
//  MenuRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MenuInteractable: Interactable, ImageboardListListener, BoardsListListener {
    var router: MenuRouting? { get set }
    var listener: MenuListener? { get set }
}

protocol MenuViewControllable: ViewControllable {
    
    func setup(views: [UIViewController])
    
    func select(page idx: Int)
    
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MenuRouter: ViewableRouter<MenuInteractable, MenuViewControllable>, MenuRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MenuInteractable, viewController: MenuViewControllable, imageboardList: ImageboardListBuildable, boardList: BoardsListBuildable) {
        self.imageboardListBuilder = imageboardList
        self.boardListBuilder = boardList
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: Private
    private var imageboardListBuilder: ImageboardListBuildable
    private var imageboardList: ViewableRouting?
    
    private var boardListBuilder: BoardsListBuildable
    private var boardList: ViewableRouting?

    
    func setupViews() {
        var vcs: [UIViewController] = []
        
        if self.canDeattach(router: self.imageboardList) {
            let imageboard = self.imageboardListBuilder.build(withListener: self.interactor)
            self.attachChild(imageboard)
            self.imageboardList = imageboard
            
            vcs.append(imageboard.viewControllable.uiviewController)
        }
        
        if self.canDeattach(router: self.boardList) {
            let boardList = self.boardListBuilder.build(withListener: self.interactor)
            self.attachChild(boardList)
            self.boardList = boardList
            
            vcs.append(boardList.viewControllable.uiviewController)
        }

        
        self.viewController.setup(views: vcs)
    }
    
}
