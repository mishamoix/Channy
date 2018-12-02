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
    case darkBlue = "darkBlue"
    case macaba = "macaba"
}


struct Theme {
    var main: UIColor
    var background: UIColor
    var navigationBar: UIColor
    var navigationBarItem: UIColor
    var navigationBarTitle: UIColor
    var mainText: UIColor
    var secondText: UIColor
    var border: UIColor
    var cell: UIColor
    var cellSelected: UIColor
    var icon: UIColor
    var link: UIColor
    var quote: UIColor
    var actionButtonBorder: UIColor
    var keyboard: UIKeyboardAppearance

}


extension Theme {
    static var light = Theme(
        main: .main,
        background: .bgLight,
        navigationBar: .navBarLight,
        navigationBarItem: .main,
        navigationBarTitle: .barTitleLight,
        mainText: .textLight,
        secondText: .subTextLight,
        border: .borderLight,
        cell: .cellLight,
        cellSelected: .cellSelectedLight,
        icon: .iconLight,
        link: .main,
        quote: .unkfunc,
        actionButtonBorder: .borderLight,
        keyboard: .light
    )
    
    static var dark = Theme(
        main: .main,
        background: .bgDark,
        navigationBar: .navBarDark,
        navigationBarItem: .main,
        navigationBarTitle: .barTitleDark,
        mainText: .textDark,
        secondText: .subTextDark,
        border: .borderDark,
        cell: .cellDark,
        cellSelected: .cellSelectedDark,
        icon: .iconDark,
        link: .main,
        quote: .unkfunc,
        actionButtonBorder: .borderDarkBlue,
        keyboard: .dark
    )
    
    static var darkBlue = Theme(
        main: .main,
        background: .bgDarkBlue,
        navigationBar: .navBarDarkBlue,
        navigationBarItem: .main,
        navigationBarTitle: .barTitleDarkBlue,
        mainText: .textDarkBlue,
        secondText: .subTextDarkBlue,
        border: .borderDarkBlue,
        cell: .cellDarkBlue,
        cellSelected: .cellSelectedDarkBlue,
        icon: .iconDarkBlue,
        link: .main,
        quote: .unkfunc,
        actionButtonBorder: .borderDarkBlue,
        keyboard: .dark
    )
    
    static var macaba = Theme(
        main: .mainMacaba,
        background: .bgMacaba,
        navigationBar: .navBarMacaba,
        navigationBarItem: .mainMacaba,
        navigationBarTitle: .barTitleMacaba,
        mainText: .textMacaba,
        secondText: .subTextMacaba,
        border: .borderMacaba,
        cell: .cellMacaba,
        cellSelected: .cellSelectedMacaba,
        icon: .iconMacaba,
        link: .mainMacaba,
        quote: .unkfuncMacaba,
        actionButtonBorder: .borderMacaba,
        keyboard: .light
    )

}
