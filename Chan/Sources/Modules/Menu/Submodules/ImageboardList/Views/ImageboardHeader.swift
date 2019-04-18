//
//  ImageboardHeader.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ImageboardHeader: BaseView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    static var instance: ImageboardHeader {
        return Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as! ImageboardHeader
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupTheme() {
        self.backgroundColor = .clear
//        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.settingsButton, type: .navBarButton, subtype: .none))
    }
    
        
}
