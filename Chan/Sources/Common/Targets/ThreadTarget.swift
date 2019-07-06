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
  case load(imageboard: Int, board: String, idx: String)
}

extension ThreadTarget: TargetType {
    
    
    public var baseURL: URL {
        if Values.shared.safeMode {
            return Enviroment.default.safeModeUrl
        }

        return Enviroment.default.baseUrl        
    }
    public var path: String {
        switch self {
        case .load(let imageboard, let board, let id):
            return "\(imageboard)/\(board)/\(id)"
            
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
        return CookiesManager.allCookies()
    }
    
    
}

