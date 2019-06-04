//
//  MarkedProtocols.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation

protocol DeleteMarkServiceProtocol: BaseServiceProtocol {
    func delete(marked thread: ThreadModel)
    func deleteAll()
}

protocol WriteMarkServiceProtocol {
    func write(thread: ThreadModel)
}

protocol ReadMarkServiceProtocol: DeleteMarkServiceProtocol {
    func read(offset: Int?) -> [ThreadModel]
}


class MarkService: BaseService, WriteMarkServiceProtocol, ReadMarkServiceProtocol {
    
    
    var readQuery: NSPredicate? {
        return nil
    }
    
//    func deleteQuery(for model: ThreadModel) -> NSPredicate? {
//        return nil
//    }
    
    func write(thread: ThreadModel) {
        thread.created = Date()

        Helper.performOnBGThread {
            self.coreData.saveModel(with: thread, with: CoreDataThread.self)
        }

    }

    func read(offset: Int?) -> [ThreadModel] {

        if let models = self.coreData.findModels(with: CoreDataThread.self, predicate: self.readQuery, sorts: [NSSortDescriptor(key: "created", ascending: false)], count: BatchSize, offset: offset) as? [ThreadModel] {
          return models
      }

      return []
    }
  
    
    func delete(marked thread: ThreadModel) {
//        self.coreData.delete(with: CoreDataThread.self, predicate: self.deleteQuery(for: thread))
    }
    
    func deleteAll() {
        
    }
}
