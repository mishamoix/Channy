//
//  Theme.swift
//  Chan
//
//  Created by Mikhail Malyshev on 04/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum ThemeType: String {
//    case light = "light"
    case dark = "dark"
//    case darkBlue = "darkBlue"
//    case macaba = "macaba"
}


struct Theme {
    var text: UIColor
    var accentText: UIColor
    var thirdText: UIColor

    var cell: UIColor
    var background: UIColor
    var border: UIColor
    var accent: UIColor
    var accnt: UIColor
    var quote: UIColor

    var keyboard: UIKeyboardAppearance

}


extension Theme {
    
    
    static var dark = Theme(
        text: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1),
        accentText: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        thirdText: #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1),
        cell: #colorLiteral(red: 0.1254901961, green: 0.1098039216, blue: 0.09019607843, alpha: 1),
        background: #colorLiteral(red: 0.1529411765, green: 0.137254902, blue: 0.1254901961, alpha: 1),
        border: #colorLiteral(red: 0.7176470588, green: 0.7607843137, blue: 0.8352941176, alpha: 1),
        accent: #colorLiteral(red: 0.4039215686, green: 0.6431372549, blue: 0.9843137255, alpha: 1),
        accnt: #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1058823529, alpha: 1),
        quote: #colorLiteral(red: 0.9215686275, green: 0.9176470588, blue: 0.9098039216, alpha: 1),
    
        keyboard: UIKeyboardAppearance.dark
    )
    
//    static var light = Theme(
//        main: .main,
//        background: .bgLight,
//        navigationBar: .navBarLight,
//        navigationBarItem: .main,
//        navigationBarTitle: .barTitleLight,
//        mainText: .textLight,
//        secondText: .subTextLight,
//        border: .borderLight,
//        cell: .cellLight,
//        cellSelected: .cellSelectedLight,
//        icon: .iconLight,
//        link: .main,
//        quote: .unkfunc,
//        actionButtonBorder: .borderLight,
//        keyboard: .light
//    )
//
//    static var dark = Theme(
//        main: .main,
//        background: .bgDark,
//        navigationBar: .navBarDark,
//        navigationBarItem: .main,
//        navigationBarTitle: .barTitleDark,
//        mainText: .textDark,
//        secondText: .subTextDark,
//        border: .borderDark,
//        cell: .cellDark,
//        cellSelected: .cellSelectedDark,
//        icon: .iconDark,
//        link: .main,
//        quote: .unkfunc,
//        actionButtonBorder: .borderDarkBlue,
//        keyboard: .dark
//    )
//
//    static var darkBlue = Theme(
//        main: .main,
//        background: .bgDarkBlue,
//        navigationBar: .navBarDarkBlue,
//        navigationBarItem: .main,
//        navigationBarTitle: .barTitleDarkBlue,
//        mainText: .textDarkBlue,
//        secondText: .subTextDarkBlue,
//        border: .borderDarkBlue,
//        cell: .cellDarkBlue,
//        cellSelected: .cellSelectedDarkBlue,
//        icon: .iconDarkBlue,
//        link: .main,
//        quote: .unkfunc,
//        actionButtonBorder: .borderDarkBlue,
//        keyboard: .dark
//    )
//
//    static var macaba = Theme(
//        main: .mainMacaba,
//        background: .bgMacaba,
//        navigationBar: .navBarMacaba,
//        navigationBarItem: .mainMacaba,
//        navigationBarTitle: .barTitleMacaba,
//        mainText: .textMacaba,
//        secondText: .subTextMacaba,
//        border: .borderMacaba,
//        cell: .cellMacaba,
//        cellSelected: .cellSelectedMacaba,
//        icon: .iconMacaba,
//        link: .mainMacaba,
//        quote: .unkfuncMacaba,
//        actionButtonBorder: .borderMacaba,
//        keyboard: .light
//    )

}
