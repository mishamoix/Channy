//
//  HiddenThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 27/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class HiddenThreadCell: SwipeCollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupTheme()
    }

    func update(with model: ThreadViewModel) {
        self.title.text = model.title
        self.number.text = model.number
    }
    
    private func setupUI() {
        self.title.font = .postTitle
    }
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self.number, type: .text, subtype: .third))
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .none))
        
        self.backgroundColor = .clear
    }

}
