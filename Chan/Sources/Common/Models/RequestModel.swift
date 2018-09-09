//
//  RequestModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class RequestModel<Type> {
    var result: Type? = nil
    var error: Error? = nil
}
