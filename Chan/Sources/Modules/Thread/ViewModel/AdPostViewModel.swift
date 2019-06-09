//
//  AdPostViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class AdPostViewModel: PostViewModel {
    
    var updateAd = true
    let adUid = UUID().uuidString

    
    convenience init() {
        self.init(model: PostModel())
        
        self.type = .ad
        
    }
    
    override init(model: PostModel) {
        super.init(model: model)
    }
    
    override func calculateSize(max width: CGFloat) {
        self.height = AdHeightDefault
    }
}
