//
//  ValueMapper.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ValueMapper {
    
    class func map<T: FloatingPoint>(minRange:T, maxRange:T, minDomain:T, maxDomain:T, value:T) -> T {
        
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
}
