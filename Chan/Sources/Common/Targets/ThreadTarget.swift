//
//  ThreadTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya

enum ThreadTarget {
    case load(board: String, idx: String)
}

extension ThreadTarget: TargetType {
    
    
    public var baseURL: URL { return Enviroment.default.oldBaseUrl }
    public var path: String {
        switch self {
        case .load(let board, let idx):
            return "/\(board)/res/\(idx).json"
            
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var validationType: ValidationType {
        switch self {
        case .load:
            return .successCodes
//        default:
//            return .none
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    
}

