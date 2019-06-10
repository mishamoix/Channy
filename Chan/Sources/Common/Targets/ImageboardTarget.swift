//
//  ImageboardTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya

enum ImageboardTarget {
    case list
}

extension ImageboardTarget: TargetType {
    public var baseURL: URL { return Enviroment.default.baseUrl }
    
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
        return CookiesManager.allCookies()
    }


}
