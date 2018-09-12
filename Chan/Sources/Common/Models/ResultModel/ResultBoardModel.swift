//
//  RequestBoardModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum ResultBoardModelType {
    case first
    case page(idx: Int)
}

class ResultBoardModel<Type>: ResultModel<Type> {
    let type: ResultBoardModelType
    
    init(result: Type, type: ResultBoardModelType) {
        self.type = type
        super.init(result: result)
    }
}
