//
//  Error.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya

enum ChanError: Error {
    
    case somethingWrong(description: String?)
    case offline
    
    case badRequest // 400
    case notFound // 404
    
    case serverError // 500
    case serverNotRespond // 502
    
    
    
}


class ErrorHelper {
    
    private let error: Error?
    
    init(error: Error?) {
        self.error = error
    }
    
    func makeError() -> ChanError {
        if let error = self.error {
            if let moyaError = error as? MoyaError {
                return self.make(moya: moyaError)
            }
        }
        return .somethingWrong(description: nil)
    }
    
    private func make(moya error: MoyaError) -> ChanError {
        
        
        switch error {
        case .underlying(let err, let response):
            return .offline
        default: break
        }
        
        self.error?.localizedDescription
        
        return .somethingWrong(description: nil)
    }
}
