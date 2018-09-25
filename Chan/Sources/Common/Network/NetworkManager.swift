//
//  NetworkManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 25/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Result

class NetworkManager {
    static let `default` = NetworkManager()
    static let disposeBag = DisposeBag()
    
    let canPerformRequests: Variable<Bool> = Variable(true)
    
}
