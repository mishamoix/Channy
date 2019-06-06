//
//  AdsThreadViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class AdsThreadViewModel: ThreadViewModel {
    
    
    override func calculateSize(max width: CGFloat) -> AdsThreadViewModel {
        self.height = 120.0
        return self
    }
    
    init() {
        super.init(with: ThreadModel(uid: ""))
        self.type = .ads
    }
}
