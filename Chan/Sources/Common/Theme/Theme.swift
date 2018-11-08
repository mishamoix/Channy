//
//  Theme.swift
//  Chan
//
//  Created by Mikhail Malyshev on 04/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum ThemeType: String {
    case light = "light"
    case dark = "dark"
}


struct Theme {
    var background: UIColor
    var navigationBar: UIColor
    var navigationBarItem: UIColor
    var navigationBarTitle: UIColor
    var mainText: UIColor
    var secondText: UIColor
    var border: UIColor
    var cell: UIColor
    var icon: UIColor
}


extension Theme {
    static var light = Theme(
        background: .bgLight,
        navigationBar: .navBarLight,
        navigationBarItem: .main,
        navigationBarTitle: .barTitleLight,
        mainText: .textLight,
        secondText: .subTextLight,
        border: .borderLight,
        cell: .cellLight,
        icon: .iconLight
    )
    
    static var dark = Theme(
        background: .bgDark,
        navigationBar: .navBarDark,
        navigationBarItem: .main,
        navigationBarTitle: .barTitleDark,
        mainText: .textDark,
        secondText: .subTextDark,
        border: .borderDark,
        cell: .cellDark,
        icon: .iconDark
    )
}
