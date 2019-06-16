//
//  ThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum ThreadModelType: String {
    case none = "none"
    case history = "history"
    case favorited = "favorited"
    
    static func type(_ string: String) -> ThreadModelType {
        switch string {
        case "history":
            return .history
        case "favorited":
            return .favorited
        default:
            return .none
        }
    }
}

class ThreadModel: BaseModel, Decodable {
    
    // old
    var uid = ""
    init(uid: String, board: BoardModel? = nil) {
        self.uid = uid
        self.board = board
    }
    
    init(id: String, board: BoardModel?) {
        self.id = id
        self.board = board
    }

    
    var id: String = ""
    var board: BoardModel? = nil
    var subject: String = ""
    var content: String = ""
    var postsCount: Int = 0
    var markups: [MarkupModel] = []
    var media: [MediaModel] = []
    var posts: [PostModel] = []
    var url: String? = nil
    
    var type: ThreadModelType = .none
    
//    var favorited: Bool = false
//    var history: Bool = false
    var created: Date = Date()
    
    var hidden: Bool = false
    

    enum CodingKeys : String, CodingKey {
        case id
        case subject
        case content
        case postsCount
        case markups = "decorations"
        case files
        case url = "URL"
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
        
        if let markups = try? values.decode([MarkupModel].self, forKey: .markups) {
            self.markups = markups
        }
        
        if let files = try? values.decode([MediaModel].self, forKey: .files) {
            self.media = files
        }
        
        if let url = try? values.decode(String.self, forKey: .url) {
            self.url = url
        }
    }

    
    override func copy() -> Any {
        let thread = ThreadModel(id: self.id, board: self.board)
        thread.subject = self.subject
        thread.content = self.content
        thread.postsCount = self.postsCount
        thread.markups = self.markups

        return thread
    }

}
