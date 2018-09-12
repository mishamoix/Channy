//
//  PostModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostModel: BaseModel, Decodable {
    var uid = ""
    var name = ""
    var subject = ""
    var comment = ""
    var files: [FileModel] = []
    
    
    enum CodingKeys : String, CodingKey {
        case uid = "num"
        case name
        case subject
        case comment
        case files
    }

    
}
