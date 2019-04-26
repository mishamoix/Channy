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
    let canRefresh: Bool
    
    init(title: String, canRefresh: Bool) {
        self.title = TextStripper.fullClean(text: title)
        self.canRefresh = canRefresh
        
        super.init()
    }
    
    init(thread: ThreadModel?, canRefresh: Bool) {
        self.canRefresh = canRefresh
        
        if let thread = thread {
            self.title = TextStripper.fullClean(text: thread.subject)
        } else {
            self.title = ""
        }
        
        super.init()
    }
    
}
