//
//  MenuRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol MenuInteractable: Interactable, ImageboardListListener, BoardsListListener, BoardSelectionListener {
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
    init(interactor: MenuInteractable, viewController: MenuViewControllable, imageboardList: ImageboardListBuildable, boardList: BoardsListBuildable, boardsSelection: BoardSelectionBuildable) {
        self.imageboardListBuilder = imageboardList
        self.boardListBuilder = boardList
        self.boardsSelectionBuilder = boardsSelection
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func openBoardSelection() {
        if self.canDeattach(router: self.boardsSelection) {
            let boardsSelection = self.boardsSelectionBuilder.build(withListener: self.interactor)
            self.attachChild(boardsSelection)
            self.boardsSelection = boardsSelection
            
            self.viewController.present(vc: BaseNavigationController(rootViewController: boardsSelection.viewControllable.uiviewController))
        }
    }
    
    // MARK: Private
    private var imageboardListBuilder: ImageboardListBuildable
    private var imageboardList: ViewableRouting?
    
    private var boardListBuilder: BoardsListBuildable
    private var boardList: ViewableRouting?
    
    private var boardsSelectionBuilder: BoardSelectionBuildable
    private var boardsSelection: ViewableRouting?

    
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
