//
//  CoreDataThread.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import CoreData


@objc(CoreDataThread)
class CoreDataThread: NSManagedObject {
    // Attributes
    
    @NSManaged var id: String
    @NSManaged var content: String
    @NSManaged var subject: String
    @NSManaged var favorited: Bool
    @NSManaged var created: Date
    
    @NSManaged var cachedImageURL: String?
    
    @NSManaged var board: CoreDataBoard

    
}

extension ThreadModel: CoreDataCachedModel {
    func entity(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity: CoreDataThread? = CoreDataThread.mr_findFirst(with: self.fetching, in: context) ?? CoreDataThread.mr_createEntity(in: context)
        
        if entity?.isInserted ?? false {
            entity?.update(with: self as AnyObject)
        }
        
        if self.created != entity?.created {
            entity?.update(with: self as AnyObject)
        }
        
        return entity
    }
    
    func save(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = self.entity(in: context)
        if let ent = entity as? CoreDataImageboard, !(entity?.isInserted ?? true) {
            ent.update(with: self as AnyObject)
        }
        
        return entity
        
    }
    
    var fetching: NSPredicate {
        if let board = self.board {
            return NSPredicate(format: "id = \"\(self.id)\" AND board.id = \"\(board.id)\"")
        } else {
            return NSPredicate(format: "id = \(self.id)")
        }
    }

}

extension CoreDataThread: CacheTrackerEntity {
    func update(with model: AnyObject) {
        if let obj = model as? ThreadModel {
            self.id = obj.id
            
            self.content = obj.content
            self.subject = obj.subject
            
            self.favorited = obj.favorited
            self.created = obj.created
            
            if let board = obj.board?.entity(in: self.managedObjectContext!) as? CoreDataBoard {
                self.board = board
            }
            
            self.cachedImageURL = obj.media.first?.url?.absoluteString
            
        }
    }
    
    var model: AnyObject {
        let result = ThreadModel(id: self.id, board: nil)
        
        result.content = self.content
        result.subject = self.subject
        result.created = self.created
        result.favorited = self.favorited
        
        result.board = self.board.model as? BoardModel
        
        if let url = self.cachedImageURL {
            let media = MediaModel(url: url)
            result.media = [media]
        }
        
        return result as AnyObject
    }

}
