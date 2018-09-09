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
  
  override open var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  
  
  
  private func addPanGestureRecognizer() {
    if let interactivePopGestureRecognizer = self.interactivePopGestureRecognizer, let targets = interactivePopGestureRecognizer.value(forKey: "_targets") as? NSArray {
      let interactivePanTarget = (targets.firstObject as AnyObject).value(forKey: "target")
      
      let pan = UIPanGestureRecognizer(target: interactivePanTarget, action: NSSelectorFromString("handleNavigationTransition:"))
      self.view.addGestureRecognizer(pan)
      self.interactivePopPanGestureRecognizer = pan
      self.interactivePopGestureRecognizer?.isEnabled = false
      
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
  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
