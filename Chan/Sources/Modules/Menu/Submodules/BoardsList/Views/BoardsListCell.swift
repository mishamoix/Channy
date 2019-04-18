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
    @IBOutlet weak var canvas: ChanView!
    @IBOutlet weak var separator: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separator.isHidden = true
        
        self.setupTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func update(with model: BoardModel) {
        super.update(with: model)

        if model.name.count != 0 {
            self.title.text = "\(model.name) /\(model.id)/"
        } else {
            self.title.text = "/\(model.id)/"
        }
        
        if model.current {
            self.title.textColor = ThemeManager.shared.theme.accnt
        } else {
            self.title.textColor = ThemeManager.shared.theme.accentText
        }
    }
    
    private func setupTheme() {
        self.backgroundColor = .clear
        self.canvas.backgroundColor = .clear
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .none))        
    }
    
    
    
    
}
