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
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#44;", with: ",")
            .replacingOccurrences(of: "&#47;", with: "/")
            .replacingOccurrences(of: "&#92;", with: "\\")
            .replacingOccurrences(of: "\\n", with: " ")
            .replacingOccurrences(of: "\\r", with: "")
            .replacingOccurrences(of: "\\t", with: " ")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "<br />", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
    }
    
    static func finishHtmlToNormal(in text: NSMutableString) {
        
        text.replaceOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
    }
    
    static func finishHtmlToNormalString(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\\")
    }

    
    static func ampToNormal(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&amp;", with: "&")
    }
    
    static func clean(text: String) -> String {
//        return text
        return text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
//        let components = text.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
//        return components.filter { !$0.isEmpty }.joined(separator: " ")

//        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func fullClean(text: String) -> String {
        var newText = TextStripper.removeAllTags(in: text)
        newText = TextStripper.ampToNormal(in: newText)
        newText = TextStripper.htmlToNormal(in: newText)
        newText = TextStripper.finishHtmlToNormalString(in: newText)
        newText = TextStripper.clean(text: newText)
        return newText
    }
    
    static func onlyChars(text: String?) -> String? {
        if let text = text {
            let result = text.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
            return result.count == 0 ? nil : result
        }
        return nil
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
