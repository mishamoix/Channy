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
    private(set) var comment: NSAttributedString
    private(set) var postsCount: Int = 0
    
    private(set) var height: CGFloat = 0
    private var heightCalculated = false
    
    private(set) var messageSize: CGSize = .zero
    private(set) var titleSize: CGSize = .zero
    
    private(set) var media: MediaModel? = nil
    var favorited: Bool = false
    
    
    private var sizeCalculated: Bool = false
    
    let uid: String
    
    var file: FileModel? = nil
    
    var displayText: String? {
        return self.comment.string
    }
    var number: String {
        return "№\(self.uid)"
    }
    
    init(with model: ThreadModel) {
        
        self.uid = String(model.id)
        self.title = model.subject
        
        self.comment = TextPreparation(text: model.content, decorations: model.markups).process()
        
        self.postsCount = model.postsCount
        self.media = model.media.first
        self.favorited = model.favorited
    }
    
    func calculateSize(max width: CGFloat) -> ThreadViewModel {
//        self.height = ThreadCellMinHeight
        
        if self.sizeCalculated {
            return self
        }
        
        self.sizeCalculated = true
        
        let textMaxWidth = width - (ThreadImageLeftMargin + ThreadImageSize + ThreadImageTextMargin + ThreadTextLeftMargin)
        
        var titleSize = TextSize(text: self.title, maxWidth: textMaxWidth, font: UIFont.postTitle).calculate()
        titleSize = CGSize(width: titleSize.width, height: min(titleSize.height, ThreadTitleMaxHeight))
        self.titleSize = titleSize
        
        var messageSize = TextSize(attributed: self.comment, maxWidth: textMaxWidth).calculate()
        messageSize = CGSize(width: messageSize.width, height: min(messageSize.height, ThreadMessageMaxHeight))
        self.messageSize = messageSize
        
        self.height = ThreadTopMargin + titleSize.height + ThreadTitleMessageMargin + messageSize.height + ThreadTextBottomMargin
        
        
        return self
    }
}

extension ThreadViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.uid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? ThreadViewModel {
            return obj.uid == self.uid && obj.favorited == self.favorited
        }
        
        return false
    }
    
    
}
