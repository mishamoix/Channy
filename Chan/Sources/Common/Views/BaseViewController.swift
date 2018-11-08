//
//  BaseViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupTheme()
        
        // Do any additional setup after loading the view.
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        self.themeManager.clean()
        self.printDeinit()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle { return self.themeManager.statusBar }
    
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.view, type: .viewControllerBG, subtype: .none))
        self.themeManager.append(view: ThemeView(object: self, type: .viewController, subtype: .none))

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
