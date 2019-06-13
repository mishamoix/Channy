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
    @NSManaged var id: Int64
    @NSManaged var name: String

    @NSManaged var baseURL: String?
    @NSManaged var captchaURL: String?
    @NSManaged var logo: String?
    @NSManaged var maxImages: Int64
    @NSManaged var highlight: String?
    @NSManaged var sort: Int64
    @NSManaged var current: Bool
    
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
        return NSPredicate(format: "id = \(Int64(self.id))")
    }
    
    
}

extension CoreDataImageboard: CacheTrackerEntity {
    func update(with model: AnyObject) {
        if let obj = model as? ImageboardModel {
            self.id = Int64(obj.id)
            self.name = obj.name
            
            self.baseURL = obj.baseURL?.absoluteString
            self.logo = obj.logo?.absoluteString
            self.maxImages = Int64(obj.maxImages)

            self.highlight = obj.highlight?.hex
            
            self.captchaKey = obj.captcha?.key
            self.captchaType = obj.captcha?.type.value
            self.captchaURL = obj.captcha?.url
            
            self.sort = Int64(obj.sort)
            if let current = obj.current {
                    self.current = current
            }
            
            let coreDataBoards = self.mutableOrderedSetValue(forKey: "boards")
            for board in obj.boards {
                // TODO: refactor
                
                if let coreDataBoard = board.entityWithoutImageboard(in: self.managedObjectContext!) as? CoreDataBoard {
                    coreDataBoard.imageboard = self
                    coreDataBoards.add(coreDataBoard)
                }
                
            }
            
            self.boards = coreDataBoards
        }
    }
    
    var model: AnyObject {
        let result = ImageboardModel()
        
        result.id = Int(self.id)
        result.name = self.name
        
        result.baseURL = URL(string: self.baseURL ?? "")
        result.logo = URL(string: self.logo ?? "")
        result.maxImages = Int(self.maxImages)
        result.highlight = UIColor(hex: self.highlight)
        result.sort = Int(self.sort)
        result.current = self.current
      
        result.captcha = ImageboardModel.Captcha(type: self.captchaType, key: self.captchaKey)
        result.captcha?.url = self.captchaURL
        
        var boards: [BoardModel] = []
        for coreDataBoard in self.boards {
            
            if let board = coreDataBoard as? CoreDataBoard, let model = board.modelWithoutImageboard as? BoardModel {
                model.imageboard = result
                boards.append(model)
            }
        }
        
        result.boards = boards
        
        return result as AnyObject
    }
    
    
}
