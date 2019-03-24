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
  
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var sort: UInt64
    @NSManaged var imageboard: CoreDataImageboard
}

extension BoardModel: CoreDataCachedModel {
    func entity(in context: NSManagedObjectContext) -> NSManagedObject? {
        return self.boardEntity(in: context)
//        let entity: CoreDataBoard? = CoreDataBoard.mr_findFirst(with: self.fetching, in: context) ?? CoreDataBoard.mr_createEntity(in: context)
//        
//        if entity?.isInserted ?? false {
//            entity?.update(with: self as AnyObject)
//        }
//        
//        return entity
    }
    
    private func boardEntity(in context: NSManagedObjectContext) -> CoreDataBoard? {
        let entity: CoreDataBoard? = CoreDataBoard.mr_findFirst(with: self.fetching, in: context) ?? CoreDataBoard.mr_createEntity(in: context)
        
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
        return NSPredicate(format: "id = \"\(self.id)\"")
    }
}

extension CoreDataBoard: CacheTrackerEntity {
    func update(with model: AnyObject) {
        if let model = model as? BoardModel {
            self.id = model.id
            self.name = model.name
            self.sort = UInt64(model.sort)
            
            // TODO: refactor
//            self.imageboard = model.imageboard!.entity(in: self.managedObjectContext!) as! CoreDataImageboard
        }
    }
    var model: AnyObject {
        let model = BoardModel(id: self.id)
        model.name = self.name
        model.sort = Int(self.sort)
        
        return model as AnyObject
    }

}
