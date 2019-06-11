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
    case blue = "blue"
    case superDark = "superDark"
}


class Theme {
    let text: UIColor
    let accentText: UIColor
    let thirdText: UIColor

    let cell: UIColor
    let background: UIColor
    let border: UIColor
    let accent: UIColor
    let accnt: UIColor
    let quote: UIColor

    let keyboard: UIKeyboardAppearance
    let barStyle: UIBarStyle
    let statusBar: UIStatusBarStyle
    
    
    init(text: UIColor, accentText: UIColor, thirdText: UIColor, cell: UIColor, background: UIColor, border: UIColor, accent: UIColor, accnt: UIColor, quote: UIColor, keyboard: UIKeyboardAppearance, barStyle: UIBarStyle, statusBar: UIStatusBarStyle) {
        self.text = text
        self.accentText = accentText
        self.thirdText = thirdText
        self.cell = cell
        self.background = background
        self.border = border
        self.accent = accent
        self.accnt = accnt
        self.quote = quote
        self.keyboard = keyboard
        self.barStyle = barStyle
        self.statusBar = statusBar
    }

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
        quote: #colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.1333333333, alpha: 1),
    
        keyboard: .dark,
        barStyle: .black,
        statusBar: .lightContent
    )
    
    static var superDark = Theme(
        text: #colorLiteral(red: 0.8087419359, green: 0.8087419359, blue: 0.8087419359, alpha: 1),
        accentText: #colorLiteral(red: 0.9242227979, green: 0.9242227979, blue: 0.9242227979, alpha: 1),
        thirdText: #colorLiteral(red: 0.7222304239, green: 0.7222304239, blue: 0.7222304239, alpha: 1),
        cell: #colorLiteral(red: 0.01960784314, green: 0.01960784314, blue: 0.01960784314, alpha: 1),
        background: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        border: #colorLiteral(red: 0.7176470588, green: 0.7607843137, blue: 0.8352941176, alpha: 1),
        accent: #colorLiteral(red: 0.4039215686, green: 0.6431372549, blue: 0.9843137255, alpha: 1),
        accnt: #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1058823529, alpha: 1),
        quote: #colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.1333333333, alpha: 1),
        
        keyboard: .dark,
        barStyle: .black,
        statusBar: .lightContent
    )
    
    static var light = Theme(
        text: #colorLiteral(red: 0.1254901961, green: 0.1098039216, blue: 0.09019607843, alpha: 1),
        accentText: #colorLiteral(red: 0.07190619324, green: 0.07190619324, blue: 0.07190619324, alpha: 1),
        thirdText: #colorLiteral(red: 0.1776829822, green: 0.1776829822, blue: 0.1776829822, alpha: 1),
        cell: #colorLiteral(red: 0.9010576996, green: 0.9010576996, blue: 0.9010576996, alpha: 1),
        background: #colorLiteral(red: 0.9773113665, green: 0.9773113665, blue: 0.9773113665, alpha: 1),
        border: #colorLiteral(red: 0.7176470588, green: 0.7607843137, blue: 0.8352941176, alpha: 1),
        accent: #colorLiteral(red: 0.4039215686, green: 0.6431372549, blue: 0.9843137255, alpha: 1),
        accnt: #colorLiteral(red: 1, green: 0.4898439753, blue: 0.01706419528, alpha: 1),
        quote: #colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.1333333333, alpha: 1),
        keyboard: .light,
        barStyle: .default,
        statusBar: .default
    )
    
    static var blue = Theme(
        text: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1),
        accentText: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        thirdText: #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1),
        cell: #colorLiteral(red: 0.1333333333, green: 0.1882352941, blue: 0.2470588235, alpha: 1),
        background: #colorLiteral(red: 0.09411764706, green: 0.1333333333, blue: 0.1764705882, alpha: 1),
        border: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
        accent: #colorLiteral(red: 0.4039215686, green: 0.6431372549, blue: 0.9843137255, alpha: 1),
        accnt: #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1058823529, alpha: 1),
        quote: #colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.1333333333, alpha: 1),
        keyboard: .dark,
        barStyle: .black,
        statusBar: .lightContent
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
