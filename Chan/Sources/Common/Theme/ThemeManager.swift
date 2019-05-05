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
    case icon
    case action
}

enum ThemeViewSubtype {
    case none
    case scrollButton
    case second
    case third
    case border
    case selected
    case primary
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
        
        switch self.type {
        case .table:
            (self.view as? UITableView)?.backgroundColor = theme.background
            break
        case .collection:
            (self.view as? UICollectionView)?.backgroundColor = theme.background
            break
        case .viewControllerBG:
            (self.view as? UIView)?.backgroundColor = theme.background
            break
        case .separator:
            (self.view as? UIView)?.backgroundColor = theme.border
            break
        case .cell:
            (self.view as? UIView)?.backgroundColor = theme.cell
            if self.subtype == .border {
                (self.view as? UIView)?.layer.borderColor = theme.border.cgColor
            } else if self.subtype == .selected {
                (self.view as? UIView)?.backgroundColor = theme.background
            }
            break

        case .input:
            if let textView = self.view as? UITextView {
                textView.backgroundColor = theme.background
                textView.textColor = theme.accentText
                textView.keyboardAppearance = theme.keyboard
            }
            
            if let textField = self.view as? UITextField {
                textField.backgroundColor = theme.background
                textField.textColor = theme.accentText
                textField.keyboardAppearance = theme.keyboard
            }
            
            if let searchBar = self.view as? UISearchBar {
                searchBar.barStyle = .black
//                searchBar.backgroundColor = theme.background
//                searchBar.tintColor = theme.accentText
//                searchBar.keyboardAppearance = theme.keyboard
//                searchBar.
            }
            break
        case .text:
            
            var color = theme.accentText
            if self.subtype == .primary {
                color = theme.accnt
            } else if self.subtype == .second {
                color = theme.accentText
            } else if self.subtype == .third {
                color = theme.thirdText
            }
            
//            var color = self.subtype == .second ? theme.text : theme.accentText
//            color = self.subtype == .primary ? theme.accnt : color
            (view as? UILabel)?.textColor = color
            (view as? TGReusableLabel)?.textColor = color
            (view as? TGReusableLabel)?.setNeedsDisplay()
            break
        case .navBar:
            if let navBar = self.view as? UINavigationBar {
                navBar.barTintColor = theme.background
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.accentText]
                navBar.isTranslucent = false
                navBar.layoutIfNeeded()
            }
        case .icon:
            (view as? UIImageView)?.tintColor = theme.accnt
        case .navBarButton:
            (view as? UIBarButtonItem)?.tintColor = theme.accnt
            (view as? UIButton)?.tintColor = theme.accnt
        case .viewController:
            break
        case .action:
            (self.view as? UIView)?.backgroundColor = theme.cell
            if self.subtype == .border {
//                (self.view as? UIView)?.layer.borderColor = theme.actionButtonBorder.cgColor
            }

            break
        }
        
    }
    
    func reloadStatusBar(theme: Theme) {
        if self.type == .viewController {
            if let vc = self.view as? UIViewController {
                vc.setNeedsStatusBarAppearanceUpdate()
            }
        }
        
        UIBarButtonItem.appearance().tintColor = theme.accnt
    }
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    var statusBar: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
//        if [.dark, .darkBlue].contains(self.savedThemeType) {
//            return UIStatusBarStyle.lightContent
//        }
//
//        return UIStatusBarStyle.default
    }
    
    var savedThemeType: ThemeType {
        return self.themeType(from: Values.shared.currentTheme)
    }
    

    
//    private let _views: NSHashTable<ThemeView> = NSHashTable<ThemeView>(options: NSPointerFunctions.Options.weakMemory)
    private var views: [ThemeView] = []
    
    private(set) var theme: Theme!
    
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
//        if self.savedThemeType == .dark {
//            self.save(theme: .light)
//        } else {
            self.save(theme: .dark)

//        }
    }
    
    func save(theme: ThemeType) {
        if theme != self.savedThemeType {
            Values.shared.currentTheme = theme.rawValue
            self.themeChanged()
          
          StatisticManager.event(name: "change_theme", values: ["type" : ThemeManager.shared.savedThemeType.rawValue])
//            Helper.performOnUtilityThread {
//                Analytics.logEvent("change_theme", parameters: ["type" : ThemeManager.shared.savedThemeType.rawValue])
//            }
            
        }
    }
    
    func themeChanged() {
        self.theme = self.theme(for: self.savedThemeType)
        
        UIView.animate(withDuration: AnimationDuration) {
            for view in self.views {
                view.apply(theme: self.theme)
                view.reloadStatusBar(theme: self.theme)
            }
        }
    }
    
    func clean() {
        self.views = self.views.filter({ $0.view != nil })
    }
    
    private func theme(for type: ThemeType) -> Theme {
//        if type == .dark {
            return Theme.dark
//        } else if type == .darkBlue {
//            return Theme.darkBlue
//        } else if type == .macaba {
//            return Theme.macaba
//        }
//
//        return Theme.light
    }
    
    private func themeType(from string: String) -> ThemeType {
//        if string == "dark" {
            return .dark
//        } else if string == "darkBlue" {
//            return .darkBlue
//        } else if  string == "macaba" {
//            return .macaba
//        }
//
//        return .light
    }
    
    
    
}
