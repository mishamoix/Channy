//
//  2chLinkModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ChanLinkModel: BaseModel {
    let board: String?
    let thread: String?
    let post: String?
    
    init(board: String?, thread: String?, post: String?) {
        self.board = board
        self.thread = thread
        self.post = post
    }
}
