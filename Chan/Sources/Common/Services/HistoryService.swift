//
//  HistoryService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

protocol WriteHistoryServiceProtocol {
    func write(thread: ThreadModel)
}

protocol ReadHistoryServiceProtocol {
    func read() -> [ThreadModel]
}

class HistoryService: BaseService, WriteHistoryServiceProtocol {

    func write(thread: ThreadModel) {
        thread.created = Date()

        Helper.performOnBGThread {
            self.coreData.saveModel(with: thread, with: CoreDataThread.self)
        }
        
    }
    
    func read() -> [ThreadModel] {
        
        if let models = self.coreData.findModels(with: CoreDataThread.self) as? [ThreadModel] {
            return models
        }
        
        return []
    }
}
