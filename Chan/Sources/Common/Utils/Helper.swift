//
//  Helper.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class Helper {
    class func open(url: URL?) {
        LinkOpener.shared.open(url: url)

    }
    
    class func openInSafari(url: URL?) {
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
  
    class func buildProxyURL(url: String) -> String {
        let cookies = (CookiesManager.cookieString() ?? "").replacingOccurrences(of: " ", with: "+")
        
        let result = "\(Enviroment.default.baseUrlProxy)?url=\(url)&cookies=\(cookies)"
        return result
    }
    
    class func prepareMediaProxyIfNeededPath(media: MediaModel?) -> String? {
        guard let media = media, let url = media.url else { return nil }
        
        if CensorManager.isCensored(model: media) {
            return Helper.buildProxyURL(url: url.absoluteString)
        } else {
            return url.absoluteString
        }
    }
    
    class func prepareMediaProxyIfNeededURL(media: MediaModel?) -> URL? {
        guard let media = media, let url = media.url else { return nil }
        
        if CensorManager.isCensored(model: media) {
            
            let cookies = (CookiesManager.cookieString() ?? "").replacingOccurrences(of: " ", with: "+")
            let params = Helper.percentEncoding(string: "?url=\(url)&cookies=\(cookies)")
            
            let result = "\(Enviroment.default.baseUrlProxy)\(params)"
            return URL(string: result)
        } else {
            return url
        }
    }

    static func percentEncoding(string: String) -> String {
        let charSet = CharacterSet.urlHostAllowed
        
        var result = string.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
        result = result.replacingOccurrences(of: "=", with: "%3D")
        result = result.replacingOccurrences(of: ";", with: "%3B")
        result = result.replacingOccurrences(of: "&", with: "%26")
        return result
    }
    
    static var rxBackgroundThread = ConcurrentDispatchQueueScheduler(qos: .background)
    static var rxBackgroundPriorityThread = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    static var createRxBackgroundThread: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
    static var rxMainThread = MainScheduler.instance
    
    static func performOnMainThread(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    static func performOnUtilityThread(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            block()
        }
    }
    
    static func performOnBGThread(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            block()
        }
    }
    
    static func performOnQueue(q: DispatchQueue, _ block: @escaping () -> ()) {
        q.async {
            block()
        }
//        DispatchQueue.global(qos: DispatchQoS.QoSClass)
    }

    
    static func openInBrowser(path: String?) {
        LinkOpener.shared.open(path: path)

//        if let path = path, let url = URL(string: path) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//
//        }
    }
    
    static func buildProxy(with model: ProxyModel? = nil) -> [AnyHashable: Any]? {
        if let proxy = model {
            var proxyConfiguration = [AnyHashable: Any]()
            
            proxyConfiguration[kCFStreamPropertySOCKSProxyHost] = proxy.server
            proxyConfiguration[kCFStreamPropertySOCKSProxyPort] = proxy.port
            proxyConfiguration[kCFStreamPropertySOCKSVersion] = kCFStreamSocketSOCKSVersion5
            
            if let username = proxy.username, username.count > 0 {
                proxyConfiguration[kCFStreamPropertySOCKSUser] = username
            }
            
            if let password = proxy.password, password.count > 0 {
                proxyConfiguration[kCFStreamPropertySOCKSPassword] = password
            }
            
            proxyConfiguration[kCFStreamPropertySOCKSProxy] = 1
            
            return proxyConfiguration

        } else {
            return nil
        }
    }
    
}
