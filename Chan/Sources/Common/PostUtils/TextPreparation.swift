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
            
//            if markup.end > self.text.count {
//                let a = 1
//            }
//
            
            let length = markup.end - markup.start
            
            let range = NSRange(location: markup.start, length: max(length, 0))
            
            switch markup.type {
                case .bold: Style.strong(text: attributed, range: range)
                case .quote: Style.quote(text: attributed, range: range)
                case .reply: Style.reply(text: attributed, range: range, reply: markup.extra["post"] as? String)
                case .spoiler: Style.spoiler(text: attributed, range: range)
                case .strikethrough: Style.strikethrough(text: attributed, range: range)
                case .link: Style.linkPost(text: attributed, range: range, url: markup.link)
                case .underline: Style.underline(text: attributed, range: range)
                case .italic: Style.italic(text: attributed, range: range)
                case .italicStrong: Style.italicStrong(text: attributed, range: range)
                case .none: break
            }
        }
        
        self.attributed = attributed
        return attributed
    }
    
    
}
