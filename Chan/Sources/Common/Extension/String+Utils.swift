//
//  String+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    
    func substring(_ from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to)
        return String(self[start ..< end])
    }
    
    func substring(in range: NSRange) -> String {
        return substring(range.location, to: range.location + range.length)
    }
    
    static func date(from date: Date) -> String {
        var result = ""
        
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()

        let todayDay = calendar.component(.day, from: today)
        let dateDay = calendar.component(.day, from: date)
        
        let todayWeek = calendar.component(.weekOfYear, from: today)
        let dateWeek = calendar.component(.weekOfYear, from: date)
        
        let todayYear = calendar.component(.year, from: today)
        let dateYear = calendar.component(.year, from: date)
        
        if todayDay == dateDay && todayWeek == dateWeek && todayYear == dateYear {
            formatter.timeStyle = .short
        } else if todayDay != dateDay && todayWeek == dateWeek && todayYear == dateYear {
            formatter.dateFormat = "MMM d, HH:mm"
        } else {
            formatter.dateFormat = "dd.MM.yy, HH:mm"
        }
        
        result = formatter.string(from: date)
        return result
    }

}
