//
//  BoardModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardModel: BaseModel, Decodable {

    var uid = ""
    var name = ""

    enum CodingKeys : String, CodingKey {
        case name
        case uid = "id"
    }
    
    init(uid: String) {
        self.uid = uid
    }
    
    func has(substring: String) -> Bool {
        let sub = substring.lowercased()
        if self.uid.lowercased().range(of: sub) != nil || self.name.lowercased().range(of: sub) != nil {
            return true
        }
        
        return false
    }
    
    
    override var debugDescription: String {
        return "uid - \(self.uid), name - \(self.name)"
    }
    
  
}
