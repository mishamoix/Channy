//
//  CoreDataStore.swift
//  Chan
//
//  Created by Mikhail Malyshev on 22/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import MagicalRecord

class CoreDataStore {
    static let shared = CoreDataStore()
    
//    let context: NSManagedObjectContext
    
    init() {
        
//        let mainContext = NSManagedObjectContext.mr_default()
//        self.context = NSManagedObjectContext.mr_context(withParent: mainContext)
        
    }
    
    func setup() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Chan")
        MagicalRecord.setLoggingLevel(.debug)
        
//        test()
    }
  
    
    func clean() {
        //        MagicalRecord.cleanUp()
    }
    
    
    
    func save(object: NSManagedObject) {
//        let mainContext = NSManagedObjectContext.mr_default()
//        let defaultContext = NSManagedObjectContext.mr_context(withParent: mainContext)
        
        
//                MagicalRecord.save({ context in
//                    var data = res?.mr_(in: context)
//                    data?.name = "Пека"
//                }) { (success, err) in
//                    print(err)
//                }
        
        

    }
    
    private func test() {
        
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
    
    
    // Write
//    func
}
