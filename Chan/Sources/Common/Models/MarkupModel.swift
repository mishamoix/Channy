//
//  MarkupModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation


class MarkupModel: BaseModel, Decodable {
    
    enum MarkupType {
        case none
        case bold
        case quote
        case reply
        case spoiler
        case strikethrough
        
        static func type(from: String) -> MarkupType {
            switch from {
            case "bold":
                return .bold
            case "quote":
                return .quote
            case "reply":
                return .reply
            case "spoiler":
                return .spoiler
            case "strikethrough":
                return .strikethrough
            default:
                return .none
            }
        }
    }
    
    var type: MarkupType = .none
    var start: Int = 0
    var end: Int = 0
    
    var extra: [String: Any] = [:]
    
    enum CodingKeys : String, CodingKey {
        case type = "kind"
        case start
        case end
        
        case post
//        case thread
    }
    
    public required init(from decoder: Decoder) throws {
        
        var extra: [String: Any] = [:]
        
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
        
        if let post = try? values.decode(String.self, forKey: .post) {
            extra["post"] = post
        }
        
        self.extra = extra
        
    }
    
    
}
