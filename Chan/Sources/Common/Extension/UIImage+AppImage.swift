//
//  UIImage+AppImage.swift
//  Chan
//
//  Created by Mikhail Malyshev on 13.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static var more: UIImage { return UIImage(named: "more")!}
    static var downArraw: UIImage { return UIImage(named: "downArrow")!}
    static var settings: UIImage { return UIImage(named: "settings")!}
    static var play: UIImage { return UIImage(named: "play")!}
    static var cross: UIImage { return UIImage(named: "cross")!}
    static var plus: UIImage { return UIImage(named: "plus")!}
    static var home: UIImage { return UIImage(named: "home")!}
    static var dragReorder: UIImage { return UIImage(named: "dragReorder")!}
    static var write: UIImage { return UIImage(named: "write")!}
    static var reply: UIImage { return UIImage(named: "reply")!}
    static var addThread: UIImage { return UIImage(named: "addThread")!}

    static var placeholder: UIImage { return UIImage(named: "imagePlaceholder")!}
    
    static var boards: UIImage { return UIImage(named: "board")!}
    static var history: UIImage { return UIImage(named: "history")!}
    static var favorites: UIImage { return UIImage(named: "favorites")!}
    
    static var addFavorite: UIImage { return UIImage(named: "addFavorites")!}
    static var hide: UIImage { return UIImage(named: "hide")!}
    
    static var star: UIImage { return UIImage(named: "star")!}
    static var fullStar: UIImage { return UIImage(named: "fullStar")!}
    
    static var postCellBG: UIImage { return UIImage(named: "threadCellBG")!}
    
    static var pauseVideo: UIImage { return UIImage(named: "pause")!}
    static var playVideo: UIImage { return UIImage(named: "playVideo")!}
    static var playerCircle: UIImage { return UIImage(named: "playerCircle")!}
    static var hideThread: UIImage { return UIImage(named: "hideThread")!}


    // onboarding
    static var onboardingAnon: UIImage { return UIImage(named: "obAnon")!}
    static var onboardingFavorites: UIImage { return UIImage(named: "obFavorites")!}
    static var onboardingHat: UIImage { return UIImage(named: "obHat")!}
    static var onboardingLegion: UIImage { return UIImage(named: "obLegion")!}
    static var onboardingTheme: UIImage { return UIImage(named: "obTheme")!}
    static var checkboxChecked: UIImage { return UIImage(named: "checkBoxChecked")!}
    static var checkboxUnchecked: UIImage { return UIImage(named: "checkBoxUnchecked")!}
}
