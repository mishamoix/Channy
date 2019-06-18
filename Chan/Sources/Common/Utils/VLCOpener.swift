//
//  VLCOpener.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class VLCOpener: NSObject {
    
    private class func scheme(url: String) -> URL? {
        return URL(string:  "vlc-x-callback://x-callback-url/stream?url=\(url)")
    }
    
    private class func checkScheme(url: String) -> URL? {
        return URL(string: "vlc://")
    }
    
    
    
    
    class func hasVLC() -> Bool {
        if let url = VLCOpener.scheme(url: "https://medomain.com/video.mp4"), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
        
    }
    
    
    class func openInVLC(url: String) {
        let path = url
        if let result = VLCOpener.scheme(url: VLCOpener.buildProxyUrl(url: path)) {
            UIApplication.shared.openURL(result)
        }
    }
  
    
  
    private class func buildProxyUrl(url: String) -> String {
        let url = Helper.buildProxyURL(url: url)
        return Helper.percentEncoding(string: url)
//        let charSet = CharacterSet.urlHostAllowed
//
//        var result = url.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
//        result = result.replacingOccurrences(of: "=", with: "%3D")
//        result = result.replacingOccurrences(of: ";", with: "%3B")
//        result = result.replacingOccurrences(of: "&", with: "%26")
//        return result
    }
}
