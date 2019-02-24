//
//  RootViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SideMenu

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: BaseViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupViews(main view: UIViewController, side menu: UIViewController) {
        self.view.backgroundColor = .red
        let menuLeftViewController = UISideMenuNavigationController(rootViewController: menu)
        
        menuLeftViewController.menuWidth = self.view.frame.width * 0.85
        
        view.willMove(toParent: self)
        self.addChild(view)
        self.view.addSubview(view.view)
        view.didMove(toParent: self)
        
        
        
//        let mainViewController = UISideMenuNavigationController(rootViewController: view)
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftViewController
//        SideMenuManager.default.
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
        self.view.isUserInteractionEnabled = true
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuShadowOpacity = 0

//SideMenuManager.default.s
//        SideMenuManager.default.menuRightNavigationController = mainViewController

    }
    
    func openMenu() {
        if let left = SideMenuManager.default.menuLeftNavigationController {
            self.present(left, animated: true, completion: nil)
        }
    }
    
    
}
