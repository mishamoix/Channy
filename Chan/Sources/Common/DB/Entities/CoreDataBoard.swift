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
}

