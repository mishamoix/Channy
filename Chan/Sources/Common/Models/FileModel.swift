//
//  ImageModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum FileType: Int, Codable {
    case image = 0
    case video = 6
}

class FileModel: BaseModel, Decodable {
    
    var name: String? = nil
    var fullname: String? = nil
    var path = ""
    var thumbnail = ""
    private var _type: FileType? = nil
    var type: FileType {
        if let innerType = self._type {
            return innerType
        }
        return .image
    }
  
  
    var url: URL? {
        return URL(string: MakeFullPath(path: self.path))
    }
  
    var urlThumb: URL? {
        return URL(string: MakeFullPath(path: self.thumbnail))
    }
  
    init(path: String) {
        self.path = path
    }
  
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try? values.decode(String.self, forKey: .name)
//        self.fullname = try? values.decode(String.self, forKey: .fullname)
        
//        self.path = try values.decode(String.self, forKey: .path)
        self.thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.path = try values.decode(String.self, forKey: .path)
      
//        if let type: Int = try? values.decode(Int.self, forKey: ._type) {
//            if [6, 10].contains(type) {
//                self._type = .video
//            }
//        }
    }
  
    
    enum CodingKeys : String, CodingKey {
        case name
        case fullname
        case path = "full"
        case thumbnail
        case _type = "type"
    }

}
