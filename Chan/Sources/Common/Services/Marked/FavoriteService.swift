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
            return NSPredicate(format: "type = \"favorited\" AND board.id = \"\(board.id)\"")
        } else {
            return NSPredicate(format: "type = \"favorited\"")
        }
    }
    
    private(set) var board: BoardModel? = nil
    
    func update(board: BoardModel) {
        self.board = board
    }
    
    override func write(thread: ThreadModel) {
//        thread.type = .favorited
        super.write(thread: thread)
    }
    
    override func delete(marked thread: ThreadModel) {
        let predicate = NSPredicate(format: "board.id = \"\(thread.board!.id)\" AND id = \"\(thread.id)\" AND type = \"favorited\"")
        self.coreData.delete(with: CoreDataThread.self, predicate: predicate)
    }
    
    override func deleteAll() {
        self.coreData.delete(with: CoreDataThread.self, predicate: self.readQuery)
    }
    
}
