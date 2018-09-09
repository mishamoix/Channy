//
//  BoardSectionModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardCategoryModel: BaseModel {

    var boards: [BoardModel] = []
    var name: String? = nil
  
    
    override var debugDescription: String {
        var result = "\(String(describing: self.name)):\n"
        for (i, board) in self.boards.enumerated() {
            result += "\(i): \(board.debugDescription)\n"
        }
        return result
    }
    
    override func copy() -> Any {
        let model = BoardCategoryModel()
        model.name = self.name
        return model
    }
    
    func has(substring: String) -> Bool {
        let sub = substring.lowercased()
        if self.name?.lowercased().range(of: sub) != nil {
            return true
        }
        
        return false
    }

}
