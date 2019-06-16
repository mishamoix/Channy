//
//  RotationManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 16/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class RotationManager {
    
    private static let shared = RotationManager()
    private var current: UIInterfaceOrientationMask = .portrait
    
    init() {}
    
    class func makeDefault() {
        RotationManager.apply(orientation: .portrait)
    }
    
    class func apply(orientation: UIInterfaceOrientationMask) {
        RotationManager.shared.current = orientation
    }
    
    static var orientation: UIInterfaceOrientationMask {
        return RotationManager.shared.current
    }
}
