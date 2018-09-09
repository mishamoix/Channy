//
//  Router+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RIBs
import UIKit

public extension Router where InteractorType: Any {
    public func canDeattach(router: ViewableRouting?) -> Bool {
        if let router = router {
            let vc = router.viewControllable.uiviewController
            if vc.parent != nil {
                return false
            }
            
            self.detachChild(router)
        }
        
        return true
    }
}
