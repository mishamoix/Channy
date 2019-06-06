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
    static let proxy = DefaultsKey<Data?>("proxy")
    static let proxyEnabled = DefaultsKey<Bool?>("proxyEnabled")

}

class Values {

    
    static let shared = Values()
    
    init() {
        self.historyWriteObservable = Variable<Bool>(false)
        self.proxyObservable = Variable<ProxyModel?>(nil)
        self.proxyEnabledObservable = Variable<Bool>(false)
//        super.init()
        
        self.historyWriteObservable.value = self.historyWrite
        self.proxyObservable.value = self.proxy
        self.proxyEnabledObservable.value = self.proxyEnabled
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
    
    
    var proxy: ProxyModel? {
        get {
            if Defaults.hasKey(.historyWrite) {
                if let value = Defaults[.proxy], let model = ProxyModel.parse(from: value) {
                    return model
                }
            }
            return nil
        }
        
        set {
            let data = newValue?.toData()
            Defaults[.proxy] = data
            self.proxyObservable.value = newValue
        }
    }
    
    var proxyObservable: Variable<ProxyModel?>
    
    var proxyEnabled: Bool {
        get {
            if Defaults.hasKey(.proxyEnabled) {
                if let value = Defaults[.proxyEnabled] {
                    return value
                }
            }
            return false
        }
        
        set {
            Defaults[.proxyEnabled] = newValue
            self.proxyEnabledObservable.value = newValue
        }
    }
    
    var proxyEnabledObservable: Variable<Bool>
    
    
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
