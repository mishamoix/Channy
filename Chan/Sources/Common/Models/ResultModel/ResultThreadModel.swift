//
//  ResultThreadModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum ResultThreadModelType {
    case all
    case replys(parent: PostModel)
    case replyed(post: PostModel)
}

class ResultThreadModel<Type>: ResultModel<Type> {
    let type: ResultThreadModelType
    
    init(result: Type, type: ResultThreadModelType) {
        self.type = type
        super.init(result: result)
    }

}
