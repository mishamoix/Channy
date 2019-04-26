//
//  TextPreparation.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class TextPreparation {
    
    private let text: String
    private let markups: [MarkupModel]
    private let font: UIFont
    
    private var attributed: NSAttributedString?
    
    var attributedText: NSAttributedString {
        return self.attributed ?? NSAttributedString(string: "")
    }
    
    

    init(text: String, decorations: [MarkupModel], font: UIFont = .text) {
        self.text = text
        self.markups = decorations
        self.font = font
    }
    
    @discardableResult
    func process() -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: self.text, attributes: [NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: ThemeManager.shared.theme.text])
        
        for markup in self.markups {
            
            let range = NSRange(location: markup.start, length: max(markup.end - markup.start - 1, 0))
            
            switch markup.type {
            case .bold: Style.strong(text: attributed, range: range)
            case .quote: Style.quote(text: attributed, range: range)
            case .none:
                break
            }
        }
        
        self.attributed = attributed
        return attributed
    }
    
    
}
