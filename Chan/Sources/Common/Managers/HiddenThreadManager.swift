//
//  HiddenThreadManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 27/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class HiddenThreadManager {
    static let shared = HiddenThreadManager()
    
    private var cache: [String: Bool] = [:]
    
    init() {}
    
    func add(thread: String) {
        self.cache[thread] = true
    }
    
    func remove(thread: String) {
        self.cache.removeValue(forKey: thread)
    }
    
    func hidden(uid: String) -> Bool {
        if let _ = self.cache[uid] {
            return true
        } else {
            return false
        }
    }
}
