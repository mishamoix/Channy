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
import SnapKit

let DarkViewMaxAlpha: Float = 0.4


protocol RootPresentableListener: class {
    func viewWillAppear()
}

final class RootViewController: BaseViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    private var menu: UISideMenuNavigationController? = nil
    private let darkView = UIView()
    private var darkViewHidden = true
    
    private var isFirstTime = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listener?.viewWillAppear()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    func setupViews(main view: UIViewController, side menu: UIViewController) {
//        self.view.backgroundColor = .red
        let menuLeftViewController = UISideMenuNavigationController(rootViewController: menu)
        self.menu = menuLeftViewController
        self.menu?.menuWidth = min(self.view.frame.width, self.view.frame.height) * 0.85
        self.menu?.sideMenuDelegate = self

//        menuLeftViewController.menuWidth = self.view.frame.width * 0.85
        
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
        
        
        self.darkView.isHidden = true
        self.darkView.backgroundColor = .darkView
        view.view.addSubview(self.darkView)
        
        self.darkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        let layer = view.view.layer
        view.view.clipsToBounds = false
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        

//SideMenuManager.default.s
//        SideMenuManager.default.menuRightNavigationController = mainViewController

    }
    
    func openMenu() {
        if let left = SideMenuManager.default.menuLeftNavigationController {
            self.present(left, animated: true, completion: nil)
        }
    }
    
    func closeMenu() {
        if let left = SideMenuManager.default.menuLeftNavigationController {
            left.dismiss(animated: true, completion: nil)
        }
    }

    
    
}


extension RootViewController: UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        self.menu(opened: true)
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        self.menu(opened: true)
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        self.menu(opened: false)
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        self.menu(opened: false)
    }
    
    
    func menu(opened: Bool) {
        if opened && self.darkViewHidden {
            self.darkView.layer.removeAllAnimations()
            
            self.darkView.layer.opacity = 0
            self.darkView.isHidden = false
            self.darkViewHidden = false
            UIView.animate(withDuration: AnimationDuration) {
                self.darkView.layer.opacity = DarkViewMaxAlpha
            }
            
        } else if !opened && !self.darkViewHidden {
            self.darkView.layer.removeAllAnimations()
            self.darkView.layer.opacity = DarkViewMaxAlpha
            self.darkViewHidden = true
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.darkView.layer.opacity = 0
            }) { finished in
                if finished {
                    self.darkView.isHidden = true
                }
            }
        }
    }
}
