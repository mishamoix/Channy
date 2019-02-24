//
//  ViewControllable+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit
import RIBs


public extension ViewControllable {

    func push(view controllable: ViewControllable, animated: Bool = true) {
        
        let vc = controllable.uiviewController
        if let vc = vc as? BaseViewController {
            vc.beforePush()
        }
        
        self.uiviewController.navigationController?.pushViewController(vc, animated: animated)
    }

    func present(view controllable: ViewControllable, animated: Bool = true) {
        self.uiviewController.present(controllable.uiviewController, animated: animated, completion: nil)
    }
    
    func present(vc: UIViewController, animated: Bool = true) {
        self.uiviewController.present(vc, animated: animated, completion: nil)
    }

    
    func setupRoot(view controllable: ViewControllable, animated: Bool = true) {
        if let nc = self.uiviewController as? UINavigationController {
            nc.setViewControllers([controllable.uiviewController], animated: animated)
        } else {
            self.uiviewController.navigationController?.setViewControllers([controllable.uiviewController], animated: animated)
        }
    }
    
    func pop(animated: Bool = true, view controllable: ViewControllable? = nil) {
        if let vc = controllable?.uiviewController {
            self.uiviewController.navigationController?.popToViewController(vc, animated: animated)
        } else {
            self.uiviewController.navigationController?.popViewController(animated: animated)
        }
    }
    
    func dismiss(animated: Bool = true) {
        self.uiviewController.dismiss(animated: animated, completion: nil)
    }
    
}


