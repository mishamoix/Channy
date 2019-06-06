//
//  ProxyService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol ProxyServiceProtocol: BaseServiceProtocol {
    func check(with proxy: ProxyModel) -> Observable<Bool>
}

class ProxyService: BaseService, ProxyServiceProtocol {
    
    private var provider: ChanProvider<ProxyTarget>?
    
    func check(with proxy: ProxyModel) -> Observable<Bool> {
        let provider = ChanProvider<ProxyTarget>(manager: ChanProvider<ProxyTarget>.defaultAlamofireManager(timeout: 5, proxy: proxy))
        
        self.provider = provider
        
        return provider
            .rx
            .request(.proxy)
            .asObservable()
            .map({ response -> Bool in
                return true
            })
    }
}
