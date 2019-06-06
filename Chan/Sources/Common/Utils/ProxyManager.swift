//
//  ProxyManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ProxyManager {
    private let disposeBag = DisposeBag()
    static let shared = ProxyManager()
    
    let proxyObservable = Variable<ProxyModel?>(nil)
    var proxy: ProxyModel? {
        return self.proxyObservable.value
    }
    
    init() {
        self.setupRx()
    }
    
    
    private func setupRx() {
        Values.shared
            .proxyEnabledObservable
            .asObservable()
            .subscribe({ [weak self] _ in
                self?.reconfigureProxy()
            })
            .disposed(by: self.disposeBag)
        
        Values.shared
            .proxyObservable
            .asObservable()
            .subscribe({ [weak self] _ in
                self?.reconfigureProxy()
            })
            .disposed(by: self.disposeBag)

    }
    
    private func reconfigureProxy() {
        var proxy: ProxyModel? = nil
        if Values.shared.proxyEnabled {
            proxy = Values.shared.proxy
        }
        
        if self.proxy != nil || proxy != nil {
            self.proxyObservable.value = proxy
        }
    }
    
}
