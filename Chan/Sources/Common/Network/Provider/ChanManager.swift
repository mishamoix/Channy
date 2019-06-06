//
//  ChanManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import RxSwift

class ChanManager: Manager {
    
//    private let disposeBag = DisposeBag()
//    
////    static let imagesManager = ChanManager()
//    
    static var imagesConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.connectionProxyDictionary = Helper.buildProxy(with: ProxyManager.shared.proxy)
        return config
    }
//    
//    override init(configuration: URLSessionConfiguration = URLSessionConfiguration.default, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
//        super.init(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
//        
//        self.setupRx()
//    }
//    
//    
//    private func setupRx() {
//        ProxyManager.shared
//            .proxyObservable
//            .asObservable()
//            .subscribe({ [weak self] _ in
//                self?.proxyUpdated()
//            })
//            .disposed(by: self.disposeBag)
//    }
//    
//    private func proxyUpdated() {
//        let proxy = Helper.buildProxy(with: ProxyManager.shared.proxy)
//        self.session.configuration.connectionProxyDictionary = proxy
//        print("SESSION PROXY \(self.session.configuration.connectionProxyDictionary)")
//    }
    
}
