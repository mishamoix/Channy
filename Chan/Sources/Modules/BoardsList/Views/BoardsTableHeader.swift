//
//  BoardsTableHeader.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardsTableHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var title: UILabel!
    func update(with model: BoardCategoryModel) {
        self.title.text = model.name
        self.canvasView.backgroundColor = UIColor.groupTableViewBackground
    }
    
}
