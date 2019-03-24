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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImage.clipsToBounds = true
        self.imageCanvas.clipsToBounds = true
        self.iconImage.layer.cornerRadius = DefaultCornerRadius
        self.imageCanvas.layer.cornerRadius = DefaultCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with model: ImageboardViewModel) {
        self.title.text = model.name
        
        if let logo = model.logo {
            self.iconImage.af_setImage(withURL: logo)
        }
        
        self.imageCanvas.backgroundColor = model.current ? model.backgroundColor : .clear
    }
    
}
