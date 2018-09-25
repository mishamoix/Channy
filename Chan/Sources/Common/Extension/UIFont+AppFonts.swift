//
//  UIFont+AppFonts.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var title: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium) }
    
    static var text: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize) }
    static var textStrong: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold) }
    static var textItalic: UIFont { return UIFont.italicSystemFont(ofSize: UIFont.systemFontSize) }
    static var textItalicStrong: UIFont { return UIFont.text.with(traits: [.traitBold, .traitItalic]) }
    
    static var postTitle: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize - 2) }

    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    



}
