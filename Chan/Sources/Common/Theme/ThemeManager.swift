//
//  ThemeManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 04/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit


enum ThemeViewType {
    case table
    case collection
//    case view
    case navBar
    case navBarButton
    case viewControllerBG
    case cell
    case text
    case separator
    case viewController
    case input
}

enum ThemeViewSubtype {
    case none
    case scrollButton
    case second
}

class ThemeView {
    weak var view: AnyObject?
    let type: ThemeViewType
    let subtype: ThemeViewSubtype
    
    init?(object: AnyObject?, type: ThemeViewType, subtype: ThemeViewSubtype) {
        if let object = object {
            self.view = object
            self.type = type
            self.subtype = subtype
        } else {
            return nil
        }
    }
    
    init?(view: UIView?, type: ThemeViewType, subtype: ThemeViewSubtype) {
        if let view = view {
            self.view = view as AnyObject
            self.type = type
            self.subtype = subtype
        } else {
            return nil
        }
    }
    
    
    func apply(theme: Theme) {
        if self.view == nil {
            return
        }
        if let tableView = self.view as? UITableView, self.type == .table {
            tableView.backgroundColor = theme.background
        } else if let navBar = self.view as? UINavigationBar, self.type == .navBar {
            navBar.barTintColor = theme.navigationBar
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTitle]
            navBar.layoutIfNeeded()
        } else if let textView = self.view as? UITextView, self.type == .input {
            textView.backgroundColor = theme.background
            textView.textColor = theme.mainText
        } else if let view = self.view as? UIView {
            if self.type == .cell {
                view.backgroundColor = theme.cell
            } else if self.type == .text {
                let color = self.subtype == .second ? theme.secondText : theme.mainText
                (view as? UILabel)?.textColor = color
                (view as? TGReusableLabel)?.textColor = color
                 (view as? TGReusableLabel)?.setNeedsDisplay()
            } else if self.type == .viewControllerBG {
                view.backgroundColor = theme.background
            } else if self.type == .separator {
                view.backgroundColor = theme.border
            }
        }
    }
    
    func reloadStatusBar() {
        if let vc = self.view as? UIViewController, self.type == .viewController {
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    var statusBar: UIStatusBarStyle {
        if self.savedThemeType == .dark {
            return UIStatusBarStyle.lightContent
        }
        
        return UIStatusBarStyle.default
    }
    
    var savedThemeType: ThemeType {
        return self.themeType(from: Values.shared.currentTheme)
    }
    

    
//    private let _views: NSHashTable<ThemeView> = NSHashTable<ThemeView>(options: NSPointerFunctions.Options.weakMemory)
    private var views: [ThemeView] = []
    
    private var theme: Theme!
    
    init() {
        self.theme = self.theme(for: self.savedThemeType)
    }
    
    func append(view: ThemeView?) {
        if let view = view {
            self.views.append(view)
            view.apply(theme: self.theme)
        }
    }
    
    func changeTheme() {
        if self.savedThemeType == .dark {
            self.save(theme: .light)
        } else {
            self.save(theme: .dark)

        }
    }
    
    func save(theme: ThemeType) {
        if theme != self.savedThemeType {
            Values.shared.currentTheme = theme.rawValue
            self.themeChanged()
        }
    }
    
    func themeChanged() {
        self.theme = self.theme(for: self.savedThemeType)
        
        UIView.animate(withDuration: AnimationDuration) {
            for view in self.views {
                view.apply(theme: self.theme)
                view.reloadStatusBar()
            }
        }
    }
    
    func clean() {
        self.views = self.views.filter({ $0.view != nil })
    }
    
    private func theme(for type: ThemeType) -> Theme {
        if type == .dark {
            return Theme.dark
        }
        
        return Theme.light
    }
    
    private func themeType(from string: String) -> ThemeType {
        if string == "dark" {
            return .dark
        }
        
        return .light
    }
    
    
    
}
