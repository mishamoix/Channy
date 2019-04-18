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
        
        self.setupTheme()
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
    
    private func setupTheme() {
        
        ThemeManager.shared.append(view: ThemeView(view: self.name, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.additionalInfo, type: .text, subtype: .second))
        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .none))

//        self.setupTheme()
//        self.themeManager.append(view: ThemeView(view: self.tableView, type: .table, subtype: .none))
    }

}
