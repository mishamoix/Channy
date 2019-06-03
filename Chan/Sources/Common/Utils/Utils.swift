//
//  Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 22/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static var mainWindow: UIWindow? {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            return window
        }
        return nil
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
