//
//  BaseService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol BaseServiceProtocol {
    func cancel()
}

class BaseService: BaseServiceProtocol {
    var disposeBag = DisposeBag()
    
    
    func cancel() {
        self.disposeBag = DisposeBag()
    }
    

}
