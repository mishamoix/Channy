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
}
