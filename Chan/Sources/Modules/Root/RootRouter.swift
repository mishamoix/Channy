//
//  RootRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, OnboardListener, BoardsListListener, MainContainerListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    
    func setupViews(main view: UIViewController, side menu: UIViewController)
    func openMenu()

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable, viewController: RootViewControllable, mainContainer: MainContainerBuildable, onboard: OnboardBuildable, boardList: BoardsListBuildable) {
        self.mainContainerBuilder = mainContainer
        self.onboardBuilder = onboard
        self.boardListBuilder = boardList
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: Private
    private let mainContainerBuilder: MainContainerBuildable
    private weak var mainContainer: ViewableRouting?

    private let onboardBuilder: OnboardBuildable
    private weak var onboard: ViewableRouting?
    
    private let boardListBuilder: BoardsListBuildable
    private weak var boardList: ViewableRouting?

    internal func setupOnboard() {
//        if self.canDeattach(router: self.onboard) {
//            let boards = self.onboardBuilder.build(withListener: self.interactor)
//            self.boards = boards
//            self.attachChild(boards)
//            self.viewControllable.setupRoot(view: boards.viewControllable, animated: false)
//        }
    }

    
    internal func setupMainViews() {
        
        var menu: UIViewController?
        var mainView: UIViewController?
        
        
        
        if self.canDeattach(router: self.mainContainer) {
            let mainContainer = self.mainContainerBuilder.build(withListener: self.interactor)
            self.mainContainer = mainContainer
            self.attachChild(mainContainer)
            
            mainView = mainContainer.viewControllable.uiviewController
//
//            if let nc = self.viewControllable.uiviewController as? UINavigationController {
////                let nc = self.viewControllable.uiviewController.navigationController
//                let vc = UIViewController()
////                vc.view.backgroundColor = .red
//                nc.setViewControllers([vc], animated: false)
//                vc.navigationController?.pushViewController(boards.viewControllable.uiviewController, animated: false)
//
            }
        
        if self.canDeattach(router: self.boardList) {
            let boardList = self.boardListBuilder.build(withListener: self.interactor)
            self.boardList = boardList
            self.attachChild(boardList)
            
            menu = boardList.viewControllable.uiviewController
        }
        
        if let menu = menu, let mainView = mainView {
            self.viewController.setupViews(main: mainView, side: menu)
        }
    }
    
    func openMenu() {
        self.viewController.openMenu()
    }
}
