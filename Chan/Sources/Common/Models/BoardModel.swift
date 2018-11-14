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

    var uid = ""
    var name = ""
    var isHome = false
    var sort = 0

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
    
    var buildLink: String? {
        let result = "\(Enviroment.default.basePath)/\(self.uid)/"
        return result
    }

    
    override var debugDescription: String {
        return "uid - \(self.uid), name - \(self.name), sort: \(self.sort)"
    }
}


extension BoardModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.uid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? BoardModel {
            return obj.uid == self.uid && obj.isHome == self.isHome
        }
        
        return false
    }
    
}
