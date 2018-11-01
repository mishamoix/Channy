//
//  BaseNavigationController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

  public var interactivePopPanGestureRecognizer: UIPanGestureRecognizer?
    
    var shouldRecognizeSimultaneously = false
  
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
    self.baseUI()
    // Do any additional setup after loading the view.
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override open var preferredStatusBarStyle: UIStatusBarStyle { return .default }
  
  
  
    private func addPanGestureRecognizer() {
        if let interactivePopGestureRecognizer = self.interactivePopGestureRecognizer, let targets = interactivePopGestureRecognizer.value(forKey: "_targets") as? NSArray {
            let interactivePanTarget = (targets.firstObject as AnyObject).value(forKey: "target")

            let pan = UIPanGestureRecognizer(target: interactivePanTarget, action: NSSelectorFromString("handleNavigationTransition:"))
            self.view.addGestureRecognizer(pan)
            self.interactivePopPanGestureRecognizer = pan
            self.interactivePopGestureRecognizer?.isEnabled = false
            pan.delegate = self
            
        }
    }
  
  private func baseUI() {
//    self.navigationBar.barTintColor = .main
//    self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.brutalMedium]
//    self.navigationBar.tintColor = .white
    
    //    let image = resizeImage(image: .leftArrow, newWidth: 13)
    //    self.navigationBar.backIndicatorImage = image
    //    self.navigationBar.backIndicatorTransitionMaskImage = image
    
  }
}


extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.shouldRecognizeSimultaneously
    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}
