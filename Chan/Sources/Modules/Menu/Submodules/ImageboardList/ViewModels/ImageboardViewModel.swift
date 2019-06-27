//
//  ImageboardViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ImageboardViewModel {
    var name: String
    var subtitle: String?
    var logo: URL?
    var current: Bool
    var backgroundColor: UIColor
    
    var hasSubtitle: Bool {
        if let subtitle = self.subtitle, subtitle.count > 0 {
            return true
        }
        
        return false
    }
    
    init(with model: ImageboardModel) {
        self.name = model.name
        self.logo = model.logo
        self.current = model.current ?? false
        self.backgroundColor = model.highlight ?? .main
        self.subtitle = model.label
    }
}
