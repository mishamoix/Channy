//
//  Enviroment.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

class Enviroment {
  
    static var `default` = Enviroment()

    var baseUrl: URL {
        return URL(string: self.basePath)!
    }
    
    var baseUrlCensor: URL {
        return URL(string: "https://censor.yablach.co")!
    }
    
    var basePath: String {
        return "https://2ch.hk"
    }
    
    var basePathWithoutScheme: String {
        return "2ch.hk"
    }
    
    

}

