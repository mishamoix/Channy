//
//  PostModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class Markup: BaseModel, Decodable {
    
    enum MarkupType {
        case none
        case bold
        case quote
        
        static func type(from: String) -> MarkupType {
            switch from {
            case "bold":
                return .bold
            case "quote":
                return .quote
            default:
                return .none
            }
        }
//        case lin
    }
    
    var type: MarkupType = .none
    var start: Int = 0
    var end: Int = 0
    
    enum CodingKeys : String, CodingKey {
        case type
        case start
        case end
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let type = try? values.decode(String.self, forKey: .type) {
            self.type = MarkupType.type(from: type)
        }
        if let start = try? values.decode(Int.self, forKey: .start) {
            self.start = start
        }
        if let end = try? values.decode(Int.self, forKey: .end) {
            self.end = end
        }        
    }


}

class PostModel: BaseModel, Decodable {
    var uid = ""
//    var name = ""
//    var subject = ""
    var comment = ""
    var files: [FileModel] = []
    var name = ""
    var date: TimeInterval = 0
    var number = 0
    
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let uidSrting = try? values.decode(String.self, forKey: .uid) {
            self.uid = uidSrting
        }
        if let uidInt = try? values.decode(Int.self, forKey: .uid) {
            self.uid = String(uidInt)
        }
        
        self.comment = try values.decode(String.self, forKey: .comment)
        if let files = try? values.decode([FileModel].self, forKey: .files) {
            self.files = files
        }
        
        self.name = try values.decode(String.self, forKey: .name)
        self.date = try values.decode(TimeInterval.self, forKey: .date)
        if let number = try? values.decode(Int.self, forKey: .number) {
            self.number = number
        }
        
    }
    
    enum CodingKeys : String, CodingKey {
        case uid = "num"
//        case name
//        case subject
        case comment
        case files
        case name
        case number
        case date = "timestamp"
    }

    
}
