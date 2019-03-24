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
    var logo: URL?
    var current: Bool
    var backgroundColor: UIColor
    
    init(with model: ImageboardModel) {
        self.name = model.name
        self.logo = model.logo
        self.current = model.current
        self.backgroundColor = model.highlight ?? .main
    }
}
