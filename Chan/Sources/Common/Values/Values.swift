//
//  Values.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import RxSwift

extension DefaultsKeys {
    static let safeMode = DefaultsKey<Bool>("safeMode")
    static let privacyPolicy = DefaultsKey<Bool>("privacyPolicy")
    static let currentTheme = DefaultsKey<String?>("currentTheme")
    static let currentBrowser = DefaultsKey<String?>("selectedBrowser")
    
    static let historyWrite = DefaultsKey<Bool?>("safeMode")
}

class Values {

    
    static let shared = Values()
    
    init() {
        self.historyWriteObservable = Variable<Bool>(false)
//        super.init()
        
        self.historyWriteObservable.value = self.historyWrite
    }
    
    var safeMode: Bool {
        get {
            if Defaults.hasKey(.safeMode) {
                return Defaults[.safeMode]
            }
            return false
        }
        
        set {
            Defaults[.safeMode] = newValue
        }
    }
    
    var censorEnabled: Bool {
        return FirebaseManager.shared.censorEnabled || self.safeMode
    }
    
    var privacyPolicy: Bool {
        get {
            return Defaults[.privacyPolicy]
        }
        
        set {
            Defaults[.privacyPolicy] = newValue
        }
    }
    
    var currentTheme: String {
        get {
            if let result = Defaults[.currentTheme] {
                return result
            }
            
            return "light"
        }
        
        set {
            Defaults[.currentTheme] = newValue
        }
    }
    
    var currentBrowser: String? {
        get {
            let value = Defaults[.currentBrowser]
            if value?.count ?? 0 == 0 {
                return nil
            }
            return value
        }
        
        set {
//            if (newValue != nil) {
                Defaults[.currentBrowser] = newValue
//            }
        }
    }
    
    var historyWrite: Bool {
        get {
            if Defaults.hasKey(.historyWrite) {
                if let value = Defaults[.historyWrite] {
                    return value
                }
            }
            return true
        }
        
        set {
            Defaults[.historyWrite] = newValue
            self.historyWriteObservable.value = newValue
        }
    }
    var historyWriteObservable: Variable<Bool>
    
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
