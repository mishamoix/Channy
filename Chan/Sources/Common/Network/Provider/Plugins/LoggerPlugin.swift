//
//  LoggerPlugin.swift
//  Chan
//
//  Created by Mikhail Malyshev on 13.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya
import Result

class LoggerPlugin: PluginType {
    
    private static var requests: [URLRequest: Date] = [:]
    
    func willSend(_ request: RequestType, target: TargetType) {
        var result = "REQUEST\n"
        result += "Method: \(target.method.rawValue.uppercased())\n"
        if let headers = target.headers {
            result += "Headers: \(headers)\n"
        }
        result += "URL:\(target.baseURL.absoluteString + target.path)\n"
        switch target.task {
        case .requestParameters(let params, _):
            result += "Query: \(params)\n"
        default: break
        }
        
        if let req = request.request {
            LoggerPlugin.requests[req] = Date()
        }
        
        print(result)
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        let end = Date()
        var res = "RESPONSE\n"
        switch result {
        case .success(let response): do {
            res += "Success\n"
            if let req = response.request {
                if let start = LoggerPlugin.requests[req] {
                    let diff = end.timeIntervalSince1970 - start.timeIntervalSince1970
                    LoggerPlugin.requests.removeValue(forKey: req)
                    res += "Duration: \(String(format: "%.3f", diff))\n"
                }
            }

            res += "URL: \(response.request?.url?.absoluteString ?? "")\n"
            if let _ = try? JSONSerialization.jsonObject(with: response.data, options: [JSONSerialization.ReadingOptions.allowFragments]) {
//                res += "Data: \(json)"
            }
            }
        case .failure(let error): do {
            
            let a = 1
        }
        }
        
        
        
        print(res)
    }

}
