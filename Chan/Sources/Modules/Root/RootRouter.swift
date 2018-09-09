//
//  RootRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, BoardsListListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable, viewController: RootViewControllable, boards: BoardsListBuildable) {
      self.boardsBuilder = boards
      super.init(interactor: interactor, viewController: viewController)
      interactor.router = self
    }

    // MARK: Private
    private let boardsBuilder: BoardsListBuildable
    private weak var boards: ViewableRouting?
    
    internal func setupBoards() {
        if self.canDeattach(router: self.boards) {
            let boards = self.boardsBuilder.build(withListener: self.interactor)
            self.boards = boards
            self.attachChild(boards)
            self.viewControllable.setupRoot(view: boards.viewControllable, animated: false)
        }
    }
}
