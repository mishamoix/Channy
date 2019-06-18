//
//  CookiesManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class CookiesManager {
    
    private static var cached: [String: String]? = nil
    
    class func allCookies() -> [String: String]? {
       
        if let cached = CookiesManager.cached {
            return cached
        }
        
        let result: [String: String] = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies ?? [])
        CookiesManager.cached = result
        
        return result
    }
    
    class func cookieString() -> String? {
        return CookiesManager.allCookies()?["Cookie"]
    }
    
    class func clearCookies() {
        CookiesManager.cached = nil
    }
}
