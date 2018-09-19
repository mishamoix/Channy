//
//  PostMainViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostMainViewModel: NSObject {

    let title: String
    
    init(title: String) {
        self.title = TextStripper.fullClean(text: title)
    }
    
}
