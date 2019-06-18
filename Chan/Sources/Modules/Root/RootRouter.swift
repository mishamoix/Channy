//
//  RootRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, OnboardListener, MenuListener, MainContainerListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    
    func setupViews(main view: UIViewController, side menu: UIViewController)
    func openMenu()
    func closeMenu()


    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable, viewController: RootViewControllable, mainContainer: MainContainerBuildable, onboard: OnboardBuildable, menu: MenuBuildable) {
        self.mainContainerBuilder = mainContainer
        self.onboardBuilder = onboard
        self.menuBuilder = menu
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: Private
    private let mainContainerBuilder: MainContainerBuildable
    private weak var mainContainer: ViewableRouting?

    private let onboardBuilder: OnboardBuildable
    private weak var onboard: ViewableRouting?
    
    private let menuBuilder: MenuBuildable
    private weak var menu: ViewableRouting?
    
    internal func setupMainViews() {
        
        if !self.showOnboardingIfNeeded() {
        
        
            var menu: UIViewController?
            var mainView: UIViewController?
            
            if self.canDeattach(router: self.mainContainer) {
                let mainContainer = self.mainContainerBuilder.build(withListener: self.interactor)
                self.mainContainer = mainContainer
                self.attachChild(mainContainer)
                
                mainView = mainContainer.viewControllable.uiviewController
            }
            
            if self.canDeattach(router: self.menu) {
                let menuModule = self.menuBuilder.build(withListener: self.interactor)
                self.menu = menuModule
                self.attachChild(menuModule)
                
                menu = menuModule.viewControllable.uiviewController
            }
            
            
            
            if let menu = menu, let mainView = mainView {
                self.viewController.setupViews(main: mainView, side: menu)
            }
        }
    }
    
    func openMenu() {
        self.viewController.openMenu()
    }
    
    func closeMenu() {
        self.viewController.closeMenu()
    }
    
    func closeOnboarding() {
        self.onboard?.viewControllable.dismiss(animated: false)
//        self.tryDeattach(router: self.onboard) { }
    }
    
    private func showOnboardingIfNeeded() -> Bool {
        if !Values.shared.onboardShows {
            if self.canDeattach(router: self.onboard) {
                let onboard = self.onboardBuilder.build(withListener: self.interactor)
                self.onboard = onboard
                self.attachChild(onboard)
                self.viewControllable.present(view: onboard.viewControllable, animated: false)
            }
            
            return true
        } else {
            return false
        }
    }
}
