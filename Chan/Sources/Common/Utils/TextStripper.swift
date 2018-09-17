//
//  TextStripper.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class TextStripper {
    
    static func removeAllTags(in text: String) -> String {
        let str = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    
    static func htmlToNormal(in text: String) -> String {
        return text
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "<br />", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#44;", with: ",")
            .replacingOccurrences(of: "&#47;", with: "/")
            .replacingOccurrences(of: "&#92;", with: "\\")
    }
    
    static func finishHtmlToNormal(in text: NSMutableString) {
        
        text.replaceOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
    }

    
    static func ampToNormal(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&amp;", with: "&")
    }
    
    static func clean(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    
//    static func replaceToNormal(in text: String) -> String {
//        return text
//            .replacingOccurrences(of: "<br>", with: "\n")
//            .replacingOccurrences(of: "&gt;", with: ">")
//            .replacingOccurrences(of: "&#47;", with: "/")
//            .replacingOccurrences(of: "&quot;", with: ">")
//
//    }
    
}
