//
//  StatusbarBackground.swift
//  Chan
//
//  Created by Mikhail Malyshev on 22/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class StatusbarBackground {
    static let shared = StatusbarBackground()
    
    private var bgView = UIView()
    
    init() {}
    
    func changeBG(color: UIColor = .black) {
        return
        self.bgView.backgroundColor = color
        guard let window = self.mainWindow else { return }
        if self.bgView.superview == nil {
            self.bgView.frame = CGRect(x: 0, y: 0, width: max(window.frame.width, window.frame.height), height: Utils.statusBarHeight)
            window.addSubview(self.bgView)
            self.bgView.layer.zPosition = 100;
            
        }
    }
    
    private var mainWindow: UIWindow? {
        return Utils.mainWindow
    }
}
