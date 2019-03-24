//
//  CoreDataStore.swift
//  Chan
//
//  Created by Mikhail Malyshev on 22/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import MagicalRecord

protocol CoreDataCachedModel {
    func entity(in context: NSManagedObjectContext) -> NSManagedObject?
    func save(in context: NSManagedObjectContext) -> NSManagedObject?
    
    var fetching: NSPredicate { get }
}


protocol CacheTrackerEntity: class {
    
    func update(with model: AnyObject)
    var model: AnyObject { get }
}


class CoreDataStore {
    static let shared = CoreDataStore()
    
    init() {
    }
    
    func setup() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Chan")
        MagicalRecord.setLoggingLevel(.debug)
        
//        test()
    }
  
    
    func clean() {
        //        MagicalRecord.cleanUp()
    }
    
    func findModels<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil) -> [AnyObject] {
        let localContext = self.localContext
        var toReturn: [AnyObject] = []
        let request = self.buildRequest(with: modelClass, predicate: predicate)
        let results = modelClass.mr_executeFetchRequest(request, in: localContext)

        for result in results ?? [] {
            if let res = result as? CacheTrackerEntity {
                toReturn.append(res.model)
            }
        }
        
        return toReturn
    }
    
    func findModel<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil) -> AnyObject? {
        let localContext = self.localContext
        var toReturn: AnyObject?
        let request = self.buildRequest(with: modelClass, predicate: predicate)
        request.fetchLimit = 1
        let results = modelClass.mr_executeFetchRequest(request, in: localContext)
        
        for result in results ?? [] {
            if let res = result as? CacheTrackerEntity {
                toReturn = res.model
            }
        }
        
        return toReturn
    }

    
    
    func saveModel<T: NSManagedObject>(with model: CoreDataCachedModel, with modelClass: T.Type) {
        self.saveModels(with: [model], with: modelClass)
    }

    
    func saveModels<T: NSManagedObject>(with models: [CoreDataCachedModel], with modelClass: T.Type) {
        let localContext = self.localContext
        
        for model in models {
            let _ = model.save(in: localContext)
        }
        
        
        localContext.mr_saveToPersistentStoreAndWait()
        
//        localContext.mr_save(options: MRSaveOptions.synchronously) { (success, error) in
//            print(success)
//            print(error)
//        }
    }
    
    
    func delete<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil) {
        let localContext = self.localContext
        localContext.performAndWait {
            if let predicate = predicate {
                modelClass.mr_deleteAll(matching: predicate, in: localContext)
            } else {
                modelClass.mr_truncateAll(in: localContext)
            }
            
            localContext.mr_saveToPersistentStoreAndWait()

            
//            localContext.mr_save(options: MRSaveOptions.synchronously, completion: { (success, error) in
//                // TDOD:
//            })
        }
    }
    
    func test() {
//        let board1 = BoardModel(uid: "b")
//        board1.name = "Бред - 4"
//        board1.isHome = true
//        
//        let board2 = BoardModel(uid: "pr")
//        board2.name = "Программач"
//        board2.isHome = false
//        
//        let board3 = BoardModel(uid: "sex")
//        board3.name = "SEEEEx"
//        board3.isHome = false
//
//        
//        self.saveModels(with: [board1, board2, board3], with: CoreDataBoard.self)
//        
//        let mmm = self.findModels(with: CoreDataBoard.self)
//        let models = mmm as? [BoardModel]
//        print(models)
////
////        
//        self.delete(with: CoreDataBoard.self)
////
//        let mmm1 = self.findModels(with: CoreDataBoard.self)
//        let models1 = mmm1 as? [BoardModel]
//        print(models1)

        
        
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(urls[urls.count-1] as URL)
//
//
//        let mainContext = NSManagedObjectContext.mr_default()
//        let defaultContext = NSManagedObjectContext.mr_context(withParent: mainContext)
//
//        var boards = CoreDataBoard.mr_findAll()
//        let a = 1
//
//
//        var res: CoreDataBoard?
//        for board in boards ?? [] {
//            if let b = board as? CoreDataBoard {
//                print(b)
////                res = b
//            }
//        }
//
//        MagicalRecord.save({ context in
//            var data = res?.mr_(in: context)
//            data?.name = "Пека"
//        }) { (success, err) in
//            print(err)
//        }

//        var board = CoreDataBoard.mr_createEntity(in: defaultContext)
//        board?.uid = "34"
//        board?.name = "fweirofmwerfwfr"
//        board?.isHome = false
//
//        defaultContext.mr_saveToPersistentStoreAndWait()
        
//
//        //        board.mr_s
    }
    
    private var localContext: NSManagedObjectContext {
        return NSManagedObjectContext.mr_context(withParent: NSManagedObjectContext.mr_rootSaving())
    }
    
    private func buildRequest<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = modelClass.mr_requestAll()
        request.predicate = predicate
        return request
    }
}
