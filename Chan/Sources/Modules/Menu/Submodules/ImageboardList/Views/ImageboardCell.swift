//
//  ImageboardCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageboardCell: UITableViewCell {
    
    @IBOutlet weak var imageCanvas: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var titleCentralConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImage.clipsToBounds = true
        self.imageCanvas.clipsToBounds = true
        self.iconImage.layer.cornerRadius = DefaultCornerRadius
        self.imageCanvas.layer.cornerRadius = DefaultCornerRadius
        self.subtitle.adjustsFontSizeToFitWidth = true
        self.setupTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with model: ImageboardViewModel) {
        self.title.text = model.name
        self.subtitle.text = model.subtitle
        if let logo = model.logo {
            self.iconImage.af_setImage(withURL: logo)
        }
        
        self.imageCanvas.backgroundColor = model.current ? model.backgroundColor : .clear
        
        if model.hasSubtitle {
            self.subtitle.isHidden = false
            self.titleTopConstraint.priority = .defaultHigh
            self.titleCentralConstraint.priority = .defaultLow
        } else {
            self.subtitle.isHidden = true
            self.titleTopConstraint.priority = .defaultLow
            self.titleCentralConstraint.priority = .defaultHigh
        }
    }
    
    func setupTheme() {
        self.backgroundColor = .clear
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .second))
        ThemeManager.shared.append(view: ThemeView(view: self.subtitle, type: .text, subtype: .third))
//        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .none))

    }
    
}
