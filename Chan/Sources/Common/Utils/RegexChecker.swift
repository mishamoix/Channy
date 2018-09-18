//
//  RegexChecker.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

class RegexChecker {
    class func check(regex: String, value: String?) -> Bool {
        if let val = value {
            if let checker = try? NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive) {
                if let result = checker.firstMatch(in: val, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: val.count)) {
                    return result.range.length == val.count
                }
            }
            
            return false
        }
        
        return true
    }
}
