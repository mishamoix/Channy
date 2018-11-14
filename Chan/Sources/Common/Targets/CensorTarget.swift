//
//  CensorTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 14/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya


enum CensorTarget {
    case censor(path: String)
}

extension CensorTarget: TargetType {
    
    public var baseURL: URL { return Enviroment.default.baseUrlCensor }
    public var path: String {
        return "/"
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .censor(let path):
            return Task.requestJSONEncodable(["image": path])
        }
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

