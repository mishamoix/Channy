//
//  UIColor+AppColor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var snow: UIColor { return #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1) }
    
    static var main: UIColor { return #colorLiteral(red: 0.9764705882, green: 0.5992317773, blue: 0.09234518882, alpha: 1) }
    static var reply: UIColor { return .main }
    
    static var spoiler: UIColor { return #colorLiteral(red: 0.5423502326, green: 0.5423502326, blue: 0.5423502326, alpha: 1) }
    static var unkfunc: UIColor { return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
}
