//
//  OnboardViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum OnboardViewModelType {
    case standart
    case last
}

class OnboardViewModel {
    let title: String
    let subtitle: String
    let image: UIImage
    let type: OnboardViewModelType
    
    init(title: String, subtitle: String, image: UIImage, type: OnboardViewModelType = .standart) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
    }
}
