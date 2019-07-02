//
//  ConfigModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/07/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ConfigModel: BaseModel, Decodable {
    
    enum CodingKeys : String, CodingKey {
        case prod = "prod_api"
        case prodCensor = "prod_censor"
        case prodProxy = "prod_proxy"
        case prodAd = "prod_ad"
        
        case dev = "dev_api"
        case devCensor = "dev_censor"
        case devProxy = "dev_proxy"
        case devAd = "dev_ad"
      
        
        case email
        case info
        case version = "app_version"

    }
    
    var prod: String
    var prodCensor: String
    var prodProxy: String
    var prodAd: String

    var dev: String
    var devCensor: String
    var devProxy: String
    var devAd: String

    var email: String
    var info: String
    var version: String
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.prod = try values.decode(String.self, forKey: .prod)
        self.prodCensor = try values.decode(String.self, forKey: .prodCensor)
        self.prodProxy = try values.decode(String.self, forKey: .prodProxy)
        self.prodAd = try values.decode(String.self, forKey: .prodAd)

        self.dev = try values.decode(String.self, forKey: .dev)
        self.devCensor = try values.decode(String.self, forKey: .devCensor)
        self.devProxy = try values.decode(String.self, forKey: .devProxy)
        self.devAd = try values.decode(String.self, forKey: .devAd)

        self.email = try values.decode(String.self, forKey: .email)
        self.info = try values.decode(String.self, forKey: .info)
        self.version = try values.decode(String.self, forKey: .version)

    }

    
}
