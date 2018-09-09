//
//  UIViewController+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit
import RIBs

extension UIViewController {
    func printDeinit() {
        let ownName = String(describing:(self))
        print("Deinit \(ownName)")
        
    }
}
