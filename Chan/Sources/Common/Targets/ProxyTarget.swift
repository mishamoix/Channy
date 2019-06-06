//
//  ProxyTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya

enum ProxyTarget {
    case proxy
}

extension ProxyTarget: TargetType {
    public var baseURL: URL { return Enviroment.default.baseUrl }
    
    public var path: String {
        return "proxy"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    
    
    var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }

}
