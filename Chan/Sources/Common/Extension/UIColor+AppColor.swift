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
    
    static var main: UIColor { return #colorLiteral(red: 1, green: 0.5607843137, blue: 0.1568627451, alpha: 1) }
    static var mainMacaba: UIColor { return #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1) }
    static var reply: UIColor { return .main }
    
    static var spoiler: UIColor { return #colorLiteral(red: 0.5423502326, green: 0.5423502326, blue: 0.5423502326, alpha: 1) }
    static var unkfunc: UIColor { return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
    static var unkfuncMacaba: UIColor { return #colorLiteral(red: 0.4705882353, green: 0.6, blue: 0.1333333333, alpha: 1) }
    
    static var scrollDown: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    static var refreshControl: UIColor { return #colorLiteral(red: 0.3905925131, green: 0.429608715, blue: 0.4824260351, alpha: 1) }
    
    static var bgLight: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var bgDark: UIColor { return #colorLiteral(red: 0.1529411765, green: 0.137254902, blue: 0.1254901961, alpha: 1) }
    static var bgDarkBlue: UIColor { return #colorLiteral(red: 0.09411764706, green: 0.1333333333, blue: 0.1764705882, alpha: 1) }
    static var bgMacaba: UIColor { return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1) }

    static var borderLight: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    static var borderDark: UIColor { return #colorLiteral(red: 0.3928315212, green: 0.3918029768, blue: 0.4097690853, alpha: 0) }
    static var borderDarkBlue: UIColor { return #colorLiteral(red: 0.3928315212, green: 0.3918029768, blue: 0.4097690853, alpha: 1) }
    static var borderMacaba: UIColor { return #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) }

    static var textLight: UIColor { return #colorLiteral(red: 0.07190619324, green: 0.07190619324, blue: 0.07190619324, alpha: 1) }
    static var textDark: UIColor { return #colorLiteral(red: 0.8345188551, green: 0.8345188551, blue: 0.8345188551, alpha: 1) }
    static var textDarkBlue: UIColor { return #colorLiteral(red: 0.8430974548, green: 0.8324901531, blue: 0.8875213061, alpha: 1) }
    static var textMacaba: UIColor { return #colorLiteral(red: 0.003921568627, green: 0.0862745098, blue: 0.1529411765, alpha: 1) }

    static var subTextLight: UIColor { return #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5607843137, alpha: 1) }
    static var subTextDark: UIColor { return #colorLiteral(red: 0.6751537359, green: 0.6791384756, blue: 0.7099554748, alpha: 1) }
    static var subTextDarkBlue: UIColor { return #colorLiteral(red: 0.822254744, green: 0.82710767, blue: 0.8646390091, alpha: 1) }
    static var subTextMacaba: UIColor { return #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5607843137, alpha: 1) }

    static var cellLight: UIColor { return #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1) }
    static var cellDark: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1098039216, blue: 0.09019607843, alpha: 1) }
    static var cellDarkBlue: UIColor { return #colorLiteral(red: 0.1333333333, green: 0.1882352941, blue: 0.2470588235, alpha: 1) }
    static var cellMacaba: UIColor { return #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1) }

    static var navBarLight: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var navBarDark: UIColor { return #colorLiteral(red: 0.05195837373, green: 0.05195837373, blue: 0.05195837373, alpha: 1) }
    static var navBarDarkBlue: UIColor { return #colorLiteral(red: 0.09411764706, green: 0.1333333333, blue: 0.1764705882, alpha: 1) }
    static var navBarMacaba: UIColor { return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1) }

    static var barTitleLight: UIColor { return #colorLiteral(red: 0.05195837373, green: 0.05195837373, blue: 0.05195837373, alpha: 1)  }
    static var barTitleDark: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var barTitleDarkBlue: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var barTitleMacaba: UIColor { return #colorLiteral(red: 0.07190619324, green: 0.07190619324, blue: 0.07190619324, alpha: 1) }

    static var iconLight: UIColor { return #colorLiteral(red: 0.5423502326, green: 0.5423502326, blue: 0.5423502326, alpha: 1)  }
    static var iconDark: UIColor { return #colorLiteral(red: 0.7609416032, green: 0.7609416032, blue: 0.7609416032, alpha: 1) }
    static var iconDarkBlue: UIColor { return #colorLiteral(red: 0.7609416032, green: 0.7609416032, blue: 0.7609416032, alpha: 1) }
    static var iconMacaba: UIColor { return #colorLiteral(red: 0.5423502326, green: 0.5423502326, blue: 0.5423502326, alpha: 1) }

    static var cellSelectedLight: UIColor { return #colorLiteral(red: 0.8056949344, green: 0.8056949344, blue: 0.8056949344, alpha: 1)  }
    static var cellSelectedDark: UIColor { return #colorLiteral(red: 0.2575905562, green: 0.2575905562, blue: 0.2575905562, alpha: 1) }
    static var cellSelectedDarkBlue: UIColor { return #colorLiteral(red: 0.2575905562, green: 0.2575905562, blue: 0.2575905562, alpha: 1) }
    static var cellSelectedMacaba: UIColor { return #colorLiteral(red: 0.8056949344, green: 0.8056949344, blue: 0.8056949344, alpha: 1) }


    
    
}
