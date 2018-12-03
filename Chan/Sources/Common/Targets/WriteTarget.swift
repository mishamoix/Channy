//
//  WriteTarget.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya


enum WriteTarget {
    case invisibleRecaptcha
    case write(model: WriteModel)
}


extension WriteTarget: TargetType {
    public var baseURL: URL { return Enviroment.default.baseUrl }
    public var path: String {
        switch self {
        case .invisibleRecaptcha: return "/api/captcha/invisible_recaptcha/id"
        case .write: return "/makaba/posting.fcgi?json=1"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .invisibleRecaptcha: return .get
        case .write: return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .invisibleRecaptcha:
            return .requestPlain
        case .write(let model):
////            MultipartFormData(provider: "sss", name: "bbb")
//            MultipartFormData(provider: MultipartFormData.FormDataProvider., name: <#T##String#>)
//            Task.uploadCompositeMultipart([MultipartFormData], urlParameters: <#T##[String : Any]#>)
            
            var result: [MultipartFormData] = [
                MultipartFormData(provider: .data(model.boardUid.data(using: .utf8)!), name: "board"),
                MultipartFormData(provider: .data(model.threadUid.data(using: .utf8)!), name: "thread"),
                MultipartFormData(provider: .data(model.text.data(using: .utf8)!), name: "comment"),
                MultipartFormData(provider: .data("invisible_recaptcha".data(using: .utf8)!), name: "captcha_type"),
                MultipartFormData(provider: .data(model.recaptchaId.data(using: .utf8)!), name: "captcha-key"),
                MultipartFormData(provider: .data(model.recaptachToken.data(using: .utf8)!), name: "g-recaptcha-response"),
                MultipartFormData(provider: .data("post".data(using: .utf8)!), name: "task"),
            ]
            
            let imageBaseKey = "image"
            let mimeType = "image/jpeg"
            
            for (idx, image) in model.images.enumerated() {
                if let data = image.jpegData(compressionQuality: 1.0) {
                    let key = "\(imageBaseKey)\(idx+1)"
                    let filename = UUID().uuidString + ".jpeg"
                    result.append(MultipartFormData(provider: .data(data), name: key, fileName: filename, mimeType: mimeType))
                }
            }
            
            return Task.uploadMultipart(result)
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
