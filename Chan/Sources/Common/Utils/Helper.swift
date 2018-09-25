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
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static var rxBackgroundThread = ConcurrentDispatchQueueScheduler(qos: .background)
    static var rxMainThread = MainScheduler.instance
    
    static func performOnMainThread(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }
}
