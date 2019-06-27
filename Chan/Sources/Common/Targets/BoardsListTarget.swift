//
//  BoardsListTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya

enum BoardsListTarget {
  case list
}

extension BoardsListTarget: TargetType {

  
  public var baseURL: URL { return Enviroment.default.baseUrl }
  public var path: String {
    switch self {
    case .list:
      return "/makaba/mobile.fcgi"
    }
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Task {
    return .requestParameters(parameters: ["task": "get_boards"], encoding: URLEncoding.default)
  }
  
  public var validationType: ValidationType {
    switch self {
    case .list:
      return .successCodes
//    default:
//      return .none
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  public var headers: [String: String]? {
    return CookiesManager.allCookies()
  }


}
