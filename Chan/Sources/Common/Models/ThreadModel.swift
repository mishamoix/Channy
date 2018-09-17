//
//  ThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ThreadModel: BaseModel, Decodable {
    
    var uid = ""
    var filesCount = 0
    var postsCount = 0
    var posts: [PostModel] = []
    
    var board: BoardModel?
    
    func update(board: BoardModel) {
        self.board = board
    }
    
    enum CodingKeys : String, CodingKey {
        case uid = "thread_num"
        case filesCount = "files_count"
        case postsCount = "posts_count"
        case posts
    }

}
