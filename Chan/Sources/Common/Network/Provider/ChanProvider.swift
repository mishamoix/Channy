//
//  ChanProvider.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya
import Result
import RxSwift


class ChanProvider<Target: TargetType>: MoyaProvider<Target> {
    public override init(endpointClosure: @escaping EndpointClosure = ChanProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = ChanProvider.chanRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
        let plugs = plugins + [NetworkLoggerPlugin(verbose: true)]
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugs, trackInflights: trackInflights)

    }
    
    public final class func chanRequestMapping(for endpoint: Endpoint, closure: @escaping RequestResultClosure) {
        
        if NetworkManager.default.canPerformRequests.value {
            ChanProvider.defaultRequestMapping(for: endpoint, closure: closure)
        } else {
            NetworkManager.default.canPerformRequests
                .asDriver()
                .filter({ $0 })
                .drive(onNext: {  _ in
                    ChanProvider.defaultRequestMapping(for: endpoint, closure: closure)
                }).disposed(by: NetworkManager.disposeBag)
        }
    }



    
}
