//
//  DefaultNavigationController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 07/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class DefaultNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTheme()

        // Do any additional setup after loading the view.
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle { return self.themeManager.statusBar }

    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(object: self.navigationBar, type: .navBar, subtype: .none))
        self.themeManager.append(view: ThemeView(object: self, type: .viewController, subtype: .none))
        self.themeManager.append(view: ThemeView(object: self.view, type: .viewControllerBG, subtype: .none))
        
        self.navigationBar.tintColor = .main
    }
    
    deinit {
        self.themeManager.clean()
        self.printDeinit()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
