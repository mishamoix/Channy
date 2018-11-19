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
    class func open(url: URL) {
//        UIApplication.shared.openURL(url)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static var rxBackgroundThread = ConcurrentDispatchQueueScheduler(qos: .background)
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
}
