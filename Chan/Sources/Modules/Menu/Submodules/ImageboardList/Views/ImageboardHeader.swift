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
    
    
    
        
}
