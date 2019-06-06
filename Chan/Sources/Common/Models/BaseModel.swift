//
//  BaseModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
}

extension Decodable where Self: BaseModel {
    static func parse(from data: Data) -> Self? {
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return result
    }
    
    static func parseArray(from data: Data) -> [Self]? {
        guard let result = try? JSONDecoder().decode([Self].self, from: data) else {
            return nil
        }
        return result
    }
}

extension Encodable where Self: BaseModel {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
