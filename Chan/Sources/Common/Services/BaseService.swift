//
//  BaseService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol BaseServiceProtocol {
    func cancel()
    var disposeBag: DisposeBag { get }
}

class BaseService: BaseServiceProtocol {
    var disposeBag = DisposeBag()
    let coreData = CoreDataStore.shared
    
    func cancel() {
        self.disposeBag = DisposeBag()
    }
    
    func handleError(err: Error?) -> Error {
        let helper = ErrorHelper(error: err)
        return helper.makeError()
    }
    
    func fromJson(data: Data?) -> [String: Any]? {
        if let data = data, let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any] {
            return result
        }
        
        return nil
    }
    
    
    func toJson(any: Any?) -> Data? {
        if let any = any, let result = try? JSONSerialization.data(withJSONObject: any, options: .prettyPrinted) {
            return result
        }
        
        return nil
    }
    
    func toJson(dict: [String:Any]?) -> Data? {
        return self.toJson(any: dict as Any)
    }
    
    func toJson(array: [Any]?) -> Data? {
        return self.toJson(any: array as Any)
    }


}
