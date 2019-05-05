//
//  FavoriteService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class FavoriteService: MarkService {
    override var readQuery: NSPredicate? {
        if let board = self.board {
            return NSPredicate(format: "favorited = true AND board.id = \"\(board.id)\"")
        } else {
            return NSPredicate(format: "favorited = true")
        }
    }
    
    private(set) var board: BoardModel? = nil
    
    func update(board: BoardModel) {
        self.board = board
    }
    
}
