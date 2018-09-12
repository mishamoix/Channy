//
//  ThreadService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol ThreadServiceProtocol {
    
    typealias ResultType = [PostModel]?

    var thread: ThreadModel { get }
    var publish: PublishSubject<ResultType>? { get set }

    
    func load()
}

class ThreadService: BaseService, ThreadServiceProtocol {
    
    let thread: ThreadModel
    var publish: PublishSubject<ResultType>? = nil

    
    init(thread: ThreadModel) {
        self.thread = thread
    }
    
    func load() {
        
    }
    
    
}
