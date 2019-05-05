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
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask).last!
      print(path)
      
//        let docPath = path.appendingPathComponent("chan.sqlite")
//        MagicalRecord.setDefaultModelNamed("CoreDataModel.momd")
        MagicalRecord.setupCoreDataStack(withStoreNamed: "chan.sqlite")
        MagicalRecord.setLoggingLevel(.verbose)
        
//        if let model = NSManagedObjectModel.mr_default() {
//            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
////            let sqlitePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "default")!.path + "/" + DBName
////            try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL(fileURLWithPath: sqlitePath), options: [
////                    NSMigratePersistentStoresAutomaticallyOption : true,
////                    NSInferMappingModelAutomaticallyOption: true
////                ])
//            NSPersistentStoreCoordinator.mr_setDefaultStoreCoordinator(coordinator)
//            NSManagedObjectContext.mr_initializeDefaultContext(with: coordinator)
//        }
    }
  
    
    func clean() {
        //        MagicalRecord.cleanUp()
    }
    
    func findModels<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil, sorts: [NSSortDescriptor]? = nil, count: Int? = nil, offset: Int? = nil) -> [AnyObject] {
        let localContext = self.localContext
        var toReturn: [AnyObject] = []
        let request = self.buildRequest(with: modelClass, predicate: predicate, sorts: sorts, offset: offset, limit: count)
        
        localContext.performAndWait {
            let results = modelClass.mr_executeFetchRequest(request, in: localContext)
            for result in results ?? [] {
                if let res = result as? CacheTrackerEntity {
                    toReturn.append(res.model)
                }
            }
        }

        
        return toReturn
    }
    
    func findModel<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil) -> AnyObject? {
        let localContext = self.localContext
        var toReturn: AnyObject?
        let request = self.buildRequest(with: modelClass, predicate: predicate)
        request.fetchLimit = 1
        localContext.performAndWait {
            let results = modelClass.mr_executeFetchRequest(request, in: localContext)
            for result in results ?? [] {
                if let res = result as? CacheTrackerEntity {
                    toReturn = res.model
                }
            }
        }
        
        return toReturn
    }

    
    
    func saveModel<T: NSManagedObject>(with model: CoreDataCachedModel, with modelClass: T.Type, completion: (() -> ())? = nil) {
        self.saveModels(with: [model], with: modelClass, completion: completion)
    }

    
    func saveModels<T: NSManagedObject>(with models: [CoreDataCachedModel], with modelClass: T.Type, completion: (() -> ())? = nil) {
        let localContext = self.localContext
        
        localContext.performAndWait {
            for model in models {
                let _ = model.save(in: localContext)
            }
            
            localContext.mr_save(options: [MRSaveOptions.synchronously, MRSaveOptions.parentContexts], completion: { (success, error) in
                completion?()
            })
        }
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

    
    private static var sharedContext = NSManagedObjectContext.mr_context(withParent: NSManagedObjectContext.mr_rootSaving())
    private var localContext: NSManagedObjectContext {
        return CoreDataStore.sharedContext
    }
    
    private func buildRequest<T: NSManagedObject>(with modelClass: T.Type, predicate: NSPredicate? = nil, sorts: [NSSortDescriptor]? = nil, offset: Int? = nil, limit: Int? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = modelClass.mr_requestAll()
        request.predicate = predicate
        request.sortDescriptors = sorts
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        if let offset = offset {
            request.fetchOffset = offset
        }
        return request
    }
}
