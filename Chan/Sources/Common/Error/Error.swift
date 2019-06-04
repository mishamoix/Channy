//
//  Error.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Moya

enum ChanError: Error, Equatable {
    
    case somethingWrong(description: String?)
    case error(title: String, description: String)
    case offline
    case parseError
    
    case badRequest // 400
    case notFound // 404
    
    case serverError // 500
    case serverNotRespond // 502
    
    case noModel
    
    case none
    
    
    public static func == (lhs: ChanError, rhs: ChanError) -> Bool {
        return String(reflecting: lhs) == String(reflecting: rhs)
    }
    
//    // Board
//    case noHomeModel
    
}


class ErrorHelper {
    
    private let error: Error?
    
    init(error: Error?) {
        self.error = error
    }
    
    func makeError() -> Error {
        if let error = self.error {
            if let moyaError = error as? MoyaError {
                return self.make(moya: moyaError)
            } else if let err = error as? ChanError {
                return err
            }
        }
        return ChanError.somethingWrong(description: self.error?.localizedDescription)
    }
    
    private func make(moya error: MoyaError) -> ChanError {
        switch error {
        case .underlying(_, let response):
            if response == nil {
                return .offline
            } else if response?.statusCode ?? 0 == 404 {
                return .notFound
            } else if let errJSON = try? response?.mapJSON() as? [String: Any], let value = errJSON?["error"] as? String {
                return .error(title: "Ошибка", description: value)
            }
        default: break
        }
        
        return .somethingWrong(description: error.localizedDescription)
    }
}
