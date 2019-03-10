//
//  ImageboardModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ImageboardModel: BaseModel, Decodable {
    var name: String = ""
    var baseURL: String = ""
    var logo: String = ""
    var highlight: String = ""
    var boards: [BoardModel] = []
    
    override init() {
        super.init()
    }
    
    enum CodingKeys : String, CodingKey {
        case name
        case baseURL
        case logo
        case highlight
        case boards
    }

}
