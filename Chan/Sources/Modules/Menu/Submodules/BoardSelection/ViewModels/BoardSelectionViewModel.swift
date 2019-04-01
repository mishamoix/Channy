//
//  BoardSelectionViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardSelectionViewModel {
    
    let id: String
    let name: String
    var selected: Bool = false
    
    var substring = ""
    
    init(model: BoardModel) {
        self.id = model.id
        self.name = model.name
        self.selected = model.selected
        
        self.substring = "/\(self.id)/ \(self.name)"
    }
}
