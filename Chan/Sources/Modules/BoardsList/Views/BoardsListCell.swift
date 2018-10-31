//
//  BoardsListCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardsListCell: BaseTableViewCell<BoardModel> {

    @IBOutlet weak var title: ChanLabel!
    @IBOutlet weak var arrow: ChanImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.arrow.tintColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func update(with model: BoardModel) {
        super.update(with: model)
        if model.isHome {
            self.arrow.image = .home
        } else {
            self.arrow.image = .more
        }
        
        if model.name.count != 0 {
            self.title.text = "\(model.name) /\(model.uid)/"
        } else {
            self.title.text = "/\(model.uid)/"
        }
    }
    
    
    
    
}
