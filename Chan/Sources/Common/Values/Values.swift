//
//  Values.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let fullAccess = DefaultsKey<Bool>("fullAccess")
}

class Values {

    
    static let shared = Values()
    
    var fullAccess: Bool {
        get {
            return Defaults[.fullAccess]
        }
        
        set {
            Defaults[.fullAccess] = newValue
        }
    }
    
    private let defaults = UserDefaults(suiteName: "chan")
    
    static func setup() {
        let _ = Values.shared
    }
    
//    func saveFullAccess(_ access: Bool) {
//        self.saveValue(for: Key.fullAccess.rawValue, value: access)
//    }
//
    private func getValue<T>(for key: String) -> T? {
        if let val = self.defaults?.value(forKey: key) as? T {
            return val
        }
        
        return nil
    }
    
    private func saveValue<T: Any>(for key: String, value: T) {
        self.defaults?.set(value, forKey: key)
        self.defaults?.synchronize()
    }
    
}
