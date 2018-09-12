//
//  BoardTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya


enum BoardTarget {
    case mainPage(board: String)
    case page(board: String ,page: Int)
}


extension BoardTarget: TargetType {
    
    
    public var baseURL: URL { return Enviroment.default.baseUrl }
    public var path: String {
        switch self {
        case .mainPage(let board):
            return "/\(board)/index.json"
        case .page(let board, let page):
            return "/\(board)/\(page).json"
            
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
    
    public var validationType: ValidationType {
        switch self {
        case .mainPage:
            fallthrough
        case .page:
            return .successCodes
        default:
            return .none
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    
}

