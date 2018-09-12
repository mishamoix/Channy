//
//  ImageModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class FileModel: BaseModel, Decodable {
    
    var name = ""
    var fullname = ""
    var path = ""
    var thumbnail = ""
    
    enum CodingKeys : String, CodingKey {
        case name
        case fullname
        case path
        case thumbnail
    }

}
