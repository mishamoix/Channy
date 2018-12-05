//
//  BaseNavigationController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BaseNavigationController: DefaultNavigationController {

    public var interactivePopPanGestureRecognizer: UIPanGestureRecognizer?
    public var disableSwipe = false
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.addPanGestureRecognizer()
    }
    
    
      override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      }
    
//      override open var preferredStatusBarStyle: UIStatusBarStyle { return self.themeManager.statusBar }
    
    
        private func addPanGestureRecognizer() {

            if !self.disableSwipe {
                if let interactivePopGestureRecognizer = self.interactivePopGestureRecognizer, let targets = interactivePopGestureRecognizer.value(forKey: "_targets") as? NSArray {
                    let interactivePanTarget = (targets.firstObject as AnyObject).value(forKey: "target")

                    let pan = UIPanGestureRecognizer(target: interactivePanTarget, action: NSSelectorFromString("handleNavigationTransition:"))
                    self.view.addGestureRecognizer(pan)
                    self.interactivePopPanGestureRecognizer = pan
                    self.interactivePopGestureRecognizer?.isEnabled = false
//                    self.interactivePopGestureRecognizer?.delegate = nil
                    pan.delegate = self
                    
                }
            }
        }
}


extension BaseNavigationController: UIGestureRecognizerDelegate {
    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return self.shouldRecognizeSimultaneously
//    }
}
