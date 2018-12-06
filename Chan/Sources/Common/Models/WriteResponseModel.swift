
//
//  WriteResponseModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum WriteResponseModel {
    case threadCreated(threadUid: String)
    case postCreated(postUid: String?)
}

//class WriteResponseModel: BaseModel {
//    var postUid: Int? = nil
//    var threadUid: Int? = nil
//}
