//
//  Enviroment.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

enum EnviromentType {
    case dev
    case prod
}

class Enviroment {
  
    static var `default` = Enviroment()
    
    private var baseUrlConfig: URL = URL(string: "https://prod.channy.io/")!
    private var proxyUrlConfig: URL = URL(string: "https://proxy.channy.io/")!
    private var censorUrlConfig: URL = URL(string: "https://censor.channy.io")!

    var configUrl: URL {
        return URL(string: "https://config.channy.io")!
    }
    
    func update(with model: ConfigModel) {
        if self.type == .prod {
            if let base = URL(string: model.prod) {
                self.baseUrlConfig = base
            }
            if let proxy = URL(string: model.prodProxy) {
                self.proxyUrlConfig = proxy
            }
            if let censor = URL(string: model.prodCensor) {
                self.censorUrlConfig = censor
            }
        } else {
            if let base = URL(string: model.dev) {
                self.baseUrlConfig = base
            }
            if let proxy = URL(string: model.devProxy) {
                self.proxyUrlConfig = proxy
            }
            if let censor = URL(string: model.devCensor) {
                self.censorUrlConfig = censor
            }

        }
    }
    
    var baseUrl: URL {
        return self.baseUrlConfig
    }
    
    var baseUrlCensor: URL {
        return self.censorUrlConfig
    }
    
    var baseUrlProxy: String {
        return self.proxyUrlConfig.absoluteString
    }
    

    
    var AdUnitID: String {
        #if RELEASE
        return "ca-app-pub-2379914676870768/3063057787"
        #endif

        return "ca-app-pub-3940256099942544/2934735716"
    }
    
    
    var type: EnviromentType {
        #if RELEASE
        return .prod
        #endif
        
        return .dev

    }
    

}

