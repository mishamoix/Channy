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


class ChanProvider<Target: TargetType>: MoyaProvider<Target> {
    
    
    public override init(endpointClosure: @escaping EndpointClosure = ChanProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = ChanProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
        let plugs = plugins + [LoggerPlugin()]
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugs, trackInflights: trackInflights)

    }
    


    
}
