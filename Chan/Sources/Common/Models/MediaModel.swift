//
//  MediaModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum MediaType: String {
    case image = "image"
    case video = "video"
    
    static func type(for string: String? = nil) -> MediaType {
        guard let string = string else {
            return .image
        }
        
        if string == "video" {
            return .video
        }
        
        return .image
    }
}


class MediaModel: BaseModel, Decodable {

    var name: String? = nil
    var url: URL? = nil
    var thumbnail: URL? = nil
    var type: MediaType = .image
    
    
    init(url: String? = nil) {
        if let url = url {
            self.url = URL(string: url)
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try? values.decode(String.self, forKey: .name)
        if let urlString = try? values.decode(String.self, forKey: .url), let url = URL(string: urlString) {
            self.url = url
        }
        
        if let thumbnailString = try? values.decode(String.self, forKey: .thumbnail), let thumbnail = URL(string: thumbnailString) {
            self.thumbnail = thumbnail
        }
        
        if let type = try? values.decode(String.self, forKey: .type) {
            self.type = MediaType.type(for: type)
        }

    }
    
  
    enum CodingKeys : String, CodingKey {
        case name
        case url = "full"
        case thumbnail
        case type = "kind"
    }
}
