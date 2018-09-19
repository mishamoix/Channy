//
//  Style.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class Style {

//    class func reply(text: String) -> NSAttributedString {
//        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.text, NSAttributedStringKey.foregroundColor: UIColor.reply])
//    }
    
    class func post(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.text, NSAttributedStringKey.foregroundColor: UIColor.black])
    }
    
    class func postTitle(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.postTitle, NSAttributedStringKey.foregroundColor: UIColor.black])
    }
    
    class func em(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.font : UIFont.textItalic], range: range)
    }
    
    class func strong(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.font : UIFont.textStrong], range: range)
    }
    
    class func emStrong(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.font : UIFont.textItalicStrong], range: range)
    }
    
    class func underline(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle], range: range)
    }
    
    class func spoiler(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.spoiler], range: range)
    }
    
    class func quote(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.unkfunc], range: range)
    }
    
    class func linkPost(text: NSMutableAttributedString, range: NSRange, url: URL? = nil) {
        var attrs: [NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor: UIColor.reply]
        if let url = url {
            attrs[NSAttributedStringKey.link] = url
        }
        text.addAttributes(attrs, range: range)
    }
    
    class func removeLink(text: NSMutableAttributedString, range: NSRange) {
        text.removeAttribute(NSAttributedStringKey.link, range: range)
    }
    
    
//    class func spoiler(text: String) -> NSAttributedString {
//        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.text, NSAttributedStringKey.foregroundColor: UIColor.spoiler])
//    }
//
//    class func unkfunc(text: String) -> NSAttributedString {
//        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.text, NSAttributedStringKey.foregroundColor: UIColor.unkfunc])
//    }
//
//    class func strong(text: String) -> NSAttributedString {
//        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.strongText, NSAttributedStringKey.foregroundColor: UIColor.black])
//    }

}
