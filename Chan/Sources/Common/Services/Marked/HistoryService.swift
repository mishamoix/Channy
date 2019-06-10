//
//  HistoryService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit


class HistoryService: MarkService {
    
    override func write(thread: ThreadModel) {
        
        if Values.shared.historyWriteObservable.value {
            if let threadDB = self.coreData.findModel(with: CoreDataThread.self, predicate: NSPredicate(format: "id = \"\(thread.id)\"")) as? ThreadModel {
            
                if threadDB.type != .favorited  {
                    threadDB.type = .history
                    super.write(thread: threadDB)
                }
            } else {
                thread.type = .history
                super.write(thread: thread)
            }
        }
    }

    
    override var readQuery: NSPredicate? {
//        if let board = self.board {
//            return NSPredicate(format: "history = true AND board.id = \"\(board.id)\"")
//        } else {
            return NSPredicate(format: "type = \"history\"")
//        }
    }

    
    override func delete(marked thread: ThreadModel) {
        let predicate = NSPredicate(format: "board.id = \"\(thread.board!.id)\" AND id = \"\(thread.id)\" AND type = \"history\"")
        self.coreData.delete(with: CoreDataThread.self, predicate: predicate)
    }
    
    override func deleteAll() {
        self.coreData.delete(with: CoreDataThread.self, predicate: self.readQuery)
    }
}
