//
//  ThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ThreadModel: BaseModel, Decodable {
    
    // old
    var uid = ""
    init(uid: String, board: BoardModel? = nil) {
        self.uid = uid
//        self.board = board
    }
    
    var id: String = ""
    var subject: String = ""
    var content: String = ""
    var postsCount: Int = 0
    var markups: [Markup] = []
    var media: [MediaModel] = []

    enum CodingKeys : String, CodingKey {
        case id
        case subject
        case content
        case postsCount
        case markups
        case files
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? values.decode(String.self, forKey: .id) {
            self.id = id
        }
        if let subject = try? values.decode(String.self, forKey: .subject) {
            self.subject = subject
        }

        if let content = try? values.decode(String.self, forKey: .content) {
            self.content = content
        }


        if let postsCount = try? values.decode(Int.self, forKey: .postsCount) {
            self.postsCount = postsCount
        }
        
        if let markups = try? values.decode([Markup].self, forKey: .markups) {
            self.markups = markups
        }
        
        if let files = try? values.decode([MediaModel].self, forKey: .files) {
            self.media = files
        }
    }


}
