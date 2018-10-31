//
//  CoreDataBoard.swift
//  Chan
//
//  Created by Mikhail Malyshev on 22/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import CoreData


@objc(CoreDataBoard)

class CoreDataBoard: NSManagedObject {
    // Attributes
    @NSManaged var name: String
    @NSManaged var uid: String
    @NSManaged var isHome: Bool
    @NSManaged var sort: UInt64
}

extension BoardModel: CoreDataCachedModel {
    func entity(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = CoreDataBoard.mr_findFirst(with: self.fetching, in: context) ?? CoreDataBoard.mr_createEntity(in: context)
        
        if entity?.isInserted ?? false {
            entity?.update(with: self as AnyObject)
        }
        
        return entity
    }
    func save(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = self.entity(in: context)
        if let ent = entity as? CoreDataBoard, !(entity?.isInserted ?? true) {
            ent.update(with: self as AnyObject)
        }
        
        return entity
    }
    
    var fetching: NSPredicate {
        return NSPredicate(format: "uid = \"\(self.uid)\"")
    }
}

extension CoreDataBoard: CacheTrackerEntity {
    func update(with model: AnyObject) {
        if let model = model as? BoardModel {
            self.uid = model.uid
            self.name = model.name
            self.isHome = model.isHome
            self.sort = UInt64(model.sort)
        }
    }
    var model: AnyObject {
        let model = BoardModel(uid: self.uid)
        model.name = self.name
        model.isHome = self.isHome
        model.sort = Int(self.sort)
        
        return model as AnyObject
    }

}
