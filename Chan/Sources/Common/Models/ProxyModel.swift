//
//  ProxyModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ProxyModel: BaseModel, Decodable, Encodable {
    var server: String
    var port: Int
    
    var username: String?
    var password: String?
    
    init(server: String, port: Int, username: String? = nil, password: String? = nil) {
        self.server = server
        self.port = port
        self.username = username
        self.password = password
    }
    
    enum CodingKeys : String, CodingKey {
        case server
        case port
        case username
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.server, forKey: .server)
        try container.encode(self.port, forKey: .port)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.password, forKey: .password)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.server = try container.decode(String.self, forKey: .server)
        self.port = try container.decode(Int.self, forKey: .port)
        if let username = try? container.decode(String.self, forKey: .username) {
            self.username = username
        }
        if let password = try? container.decode(String.self, forKey: .password) {
            self.password = password
        }

    }

}
