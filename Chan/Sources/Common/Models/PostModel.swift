//
//  PostModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostModel: BaseModel, Decodable {
    var uid = 0
//    var name = ""
//    var subject = ""
    var comment = ""
    var files: [MediaModel] = []
    var name = ""
    var date: TimeInterval = 0
    var number = 0
    var markups: [MarkupModel] = []
    var selfReplies: [Int] = []
    
    override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let uid = try? values.decode(Int.self, forKey: .id) {
            self.uid = uid
        }
        
        
//        if let uidInt = try? values.decode(Int.self, forKey: .uid) {
//            self.uid = String(uidInt)
//        }
        
        self.comment = try values.decode(String.self, forKey: .comment)
        if let files = try? values.decode([MediaModel].self, forKey: .files) {
            self.files = files
        }
        
//        self.name = try values.decode(String.self, forKey: .name)
        self.date = try values.decode(TimeInterval.self, forKey: .date)
//        if let number = try? values.decode(Int.self, forKey: .number) {
//            self.number = number
//        }
        
        if let markups = try? values.decode([MarkupModel].self, forKey: .markups) {
            self.markups += markups
        }
        
        if let replies = try? values.decode([MarkupModel].self, forKey: .replies) {
            self.markups += replies
        }
        
        if let links = try? values.decode([MarkupModel].self, forKey: .links) {
            self.markups += links
        }

        
        if let replies = try? values.decode([Int].self, forKey: .selfReplies) {
            self.selfReplies = replies
        }

        
      
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
//        case name
//        case subject
        case comment = "content"
        case files
        case name
        case number
        case date = "timestamp"
        case markups = "decorations"
        case replies
        case selfReplies
        case links
    }

    
}
