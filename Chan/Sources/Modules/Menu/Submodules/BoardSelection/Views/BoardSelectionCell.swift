//
//  BoardSelectionCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BoardSelectionCell: UITableViewCell {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func update(with model: BoardSelectionViewModel) {
        self.name.text = model.name
        self.additionalInfo.text = model.substring
        
        self.checkmark.isHidden = !model.selected
    }
}
