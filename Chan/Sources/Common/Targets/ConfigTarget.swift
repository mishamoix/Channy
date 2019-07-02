//
//  ConfigTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/07/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya


enum ConfigTarget {
    case config
}


extension ConfigTarget: TargetType {
    public var baseURL: URL { return Enviroment.default.configUrl }
    
    public var path: String {
        return ""
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
