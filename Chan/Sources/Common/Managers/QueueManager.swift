//
//  QueueManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 16/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class QueueManager {
    static let shared = QueueManager()
    
    let fullImageCensorAddingQueue = DispatchQueue(label: "fullImageCensorAddingQueue", qos: .background)
    // DispatchQueue(label: "fullImageCensorAddingQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    
    init() {}
    
    
    
}
