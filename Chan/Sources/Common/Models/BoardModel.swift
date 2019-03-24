//
//  BoardModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import IGListKit


class BoardModel: BaseModel, Decodable {

    // remove after all refactor
    var uid: String = ""
    init(uid: String) {
        self.id = uid
    }

    
    
    var id = ""
    var name = ""
    
    var sort = 0
    var imageboard: ImageboardModel? = nil

    enum CodingKeys : String, CodingKey {
        case name
        case id
    }
    
    init(id: String) {
        self.id = id
    }
    

    
    func has(substring: String) -> Bool {
        let sub = substring.lowercased()
        if self.id.lowercased().range(of: sub) != nil || self.name.lowercased().range(of: sub) != nil {
            return true
        }
        
        return false
    }
    
    var buildLink: String? {
        let result = "\(Enviroment.default.oldBasePath)/\(self.id)/"
        return result
    }

    
    override var debugDescription: String {
        return "uid - \(self.id), name - \(self.name)"
    }
}


extension BoardModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? BoardModel {
            return obj.id == self.id
        }
        
        return false
    }
    
}
