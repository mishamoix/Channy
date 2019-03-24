//
//  CoreDataImageboard.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import CoreData


@objc(CoreDataImageboard)
class CoreDataImageboard: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var name: String

    @NSManaged var baseURL: String?
    @NSManaged var logo: String?
    @NSManaged var maxImages: NSNumber
    @NSManaged var highlight: String?
    @NSManaged var sort: NSNumber
    @NSManaged var current: NSNumber

    // captcha
    @NSManaged var captchaKey: String?
    @NSManaged var captchaType: String?
    
    // boards
    @NSManaged var boards: NSOrderedSet
    
    


}


extension ImageboardModel: CoreDataCachedModel {
    func entity(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entity: CoreDataImageboard? = CoreDataImageboard.mr_findFirst(with: self.fetching, in: context) ?? CoreDataImageboard.mr_createEntity(in: context)
        
        if entity?.isInserted ?? false {
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
        return NSPredicate(format: "id = \"\(self.id)\"")
    }
    
    
}

extension CoreDataImageboard: CacheTrackerEntity {
    func update(with model: AnyObject) {
        if let obj = model as? ImageboardModel {
            self.id = NSNumber(value: obj.id)
            self.name = obj.name
            
            self.baseURL = obj.baseURL?.absoluteString
            self.logo = obj.logo?.absoluteString
            self.maxImages = NSNumber(value: obj.maxImages)

            self.highlight = obj.highlight?.hex
            
            self.captchaKey = obj.captcha?.key
            self.captchaType = obj.captcha?.type.value
            
            self.sort = NSNumber(value: obj.sort)
            self.current = NSNumber(value: obj.current)
            
            var coreDataBoards = Set<CoreDataBoard>()
            for board in obj.boards {
                // TODO: refactor
                
                if let coreDataBoard = board.entity(in: self.managedObjectContext!) as? CoreDataBoard {
                    coreDataBoards.update(with: coreDataBoard)
                }
                
            }
            
            self.boards = NSOrderedSet(set: coreDataBoards)
        }
    }
    
    var model: AnyObject {
        let result = ImageboardModel()
        
        result.id = self.id.intValue
        result.name = self.name
        
        result.baseURL = URL(string: self.baseURL ?? "")
        result.logo = URL(string: self.logo ?? "")
        result.maxImages = self.maxImages.intValue
        result.highlight = UIColor(hex: self.highlight)
        result.sort = self.sort.intValue
        result.current = self.current.boolValue
        
        result.captcha = ImageboardModel.Captcha(type: self.captchaType, key: self.captchaKey)
        
        var boards: [BoardModel] = []
        for coreDataBoard in self.boards {
            
            if let board = coreDataBoard as? CoreDataBoard, let model = board.model as? BoardModel {
                boards.append(model)
            }
        }
        
        result.boards = boards
        
        return result as AnyObject
    }
    
    
}
