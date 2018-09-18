//
//  ThreadViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import IGListKit

class ThreadViewModel {
    
    private(set) var thumbnail: URL? = nil
    private(set) var title: String? = nil
    private(set) var comment: String? = nil
    private(set) var postsCount: Int = 0
    
    private(set) var height: CGFloat = 0
    private var heightCalculated = false
    
    private let uid: String
    
    var displayText: String {
        return "[\(self.postsCount)] " + (self.comment ?? "")
    }
    
    init(with model: ThreadModel) {
        self.uid = model.uid
        if let post = model.posts.first {
//            self.title = post.subject
            self.comment = TextStripper.removeAllTags(in: post.comment)
            self.postsCount = model.postsCount
            if let file = post.files.first {
                self.thumbnail = URL(string: MakeFullPath(path: file.thumbnail))
            }
        }
    }
    
    func calculateSize(max width: CGFloat) -> ThreadViewModel {
        
        let contentWidth = width - 2 * ThreadCellSideMargin
        
        var titleSize: CGFloat = 0
        var commentSize: CGFloat = 0
        
        if let title = self.title {
            titleSize = TextSize(text: title, maxWidth: contentWidth - 2 * ThreadCellTopMargin, font: .title).calculate().height
        }
        
        if let comment = self.comment {
            commentSize = TextSize(text: comment, maxWidth: contentWidth - ThreadCellTopMargin - ThreadCellSideMargin, font: .text).calculate().height
        }
        
//        self.height = min(commentSize + titleSize + 5 * ThreadCellTopMargin, ThreadCellMaxHeight)
        self.height = ThreadCellMinHeight
        
        return self
    }
}

extension ThreadViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.uid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? ThreadViewModel {
            return obj.uid == self.uid
        }
        
        return false
    }
    
    
}
