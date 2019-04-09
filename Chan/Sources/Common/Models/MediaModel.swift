//
//  MediaModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class MediaModel: BaseModel, Decodable {

    var name: String? = nil
    var url: URL? = nil
    var thumbnail: URL? = nil
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try? values.decode(String.self, forKey: .name)
        if let urlString = try? values.decode(String.self, forKey: .url), let url = URL(string: urlString) {
            self.url = url
        }
        
        if let thumbnailString = try? values.decode(String.self, forKey: .thumbnail), let thumbnail = URL(string: thumbnailString) {
            self.thumbnail = thumbnail
        }
    }
    
  
    enum CodingKeys : String, CodingKey {
        case name
        case url = "path"
        case thumbnail
        case type
    }
}
