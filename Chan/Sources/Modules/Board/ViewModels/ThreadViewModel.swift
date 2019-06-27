//
//  ThreadViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import IGListKit

enum ThreadViewModelType {
    case thread
    case ads
}

class ThreadViewModel {
    
    let uid: String
    var type: ThreadViewModelType

    private(set) var thumbnail: URL? = nil
    private(set) var title: String? = nil
    private(set) var comment: NSAttributedString
    private(set) var postsCount: Int = 0
    
    var height: CGFloat = 0
    private var heightCalculated = false
    
    private(set) var messageSize: CGSize = .zero
    private(set) var titleSize: CGSize = .zero
    
    private(set) var media: MediaModel? = nil
    var favorited: Bool = false
    var hidden: Bool = false {
        didSet {
            self.sizeCalculated = false
        }
    }
    
    var needReload = false
    
    private var sizeCalculated: Bool = false
    
    
    var file: MediaModel? = nil
    
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
        self.favorited = model.type == .favorited
        
        self.type = .thread
    }
    
    func calculateSize(max width: CGFloat) -> ThreadViewModel {
//        self.height = ThreadCellMinHeight
        
        if self.sizeCalculated {
            return self
        }
        
        self.sizeCalculated = true

        
        if self.hidden {
            self.height = HiddenThreadHeight
            return self
        }
        
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
        defer {
            self.needReload = false
        }
        if needReload {
            return UUID().uuidString as NSObjectProtocol
        }
        
        return self.uid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let obj = object as? ThreadViewModel {
            return obj.uid == self.uid && obj.favorited == self.favorited && obj.hidden == self.hidden
        }
        
        return false
    }
    
    
}
