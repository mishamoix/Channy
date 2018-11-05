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
}


extension Theme {
    static var light = Theme(
        background: .white,
        navigationBar: .snow,
        navigationBarItem: .main,
        navigationBarTitle: .black,
        mainText: .black,
        secondText: .subTextLight,
        border: .spoiler,
        cell: .snow
    )
    
    static var dark = Theme(
        background: .black,
        navigationBar: .black,
        navigationBarItem: .main,
        navigationBarTitle: .snow,
        mainText: .snow,
        secondText: .subTextDark,
        border: .spoiler,
        cell: .black
    )
}
