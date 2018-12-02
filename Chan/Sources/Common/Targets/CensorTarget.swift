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
            //TODO: переделать
            let cookies = self.find2chCookies()
            let result: [String: Any] = ["cookies": cookies, "image": path]
            return .requestParameters(parameters: result, encoding: JSONEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
//        return self.find2chCookies()
        return nil
    }
    
    
    private func find2chCookies() -> [String: String] {
        
        for cookie in HTTPCookieStorage.shared.cookies ?? [] {
            if cookie.domain == "2ch.hk" && cookie.name == "usercode_auth" {
                return [cookie.name: cookie.value]
            }
        }
        
        return [:]
    }
    
    
}

