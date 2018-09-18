//
//  PostViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostViewModel {
    
    let modifier: PostPreparation
    let uid: String
    let media: [FileModel]
    private var tags: [String] = []
    
    private let date: String
    private let name: String
    private let number: Int
    
    private(set) var height: CGFloat = 0
    private(set) var titleHeight: CGFloat = 0
    private(set) var textHeight: CGFloat = 0
    private var heightCalculated = false
    
    var replyPosts: [String] = []

    var text: NSAttributedString {
        return self.modifier.attributedText
    }

    
    var title: NSAttributedString {
        let number = "#\(self.number)"
        let str = "\(number) • \(self.uid) • \(self.date)"
        let result = Style.postTitle(text: str)
        Style.quote(text: result, range: NSRange(location: 0, length: number.count))
//        if self.name.lowercased() != "аноним" {
//            str = "\(str) • \(self.name)"
//        }
        return result
    }
    
    var replyedButtonText: String {
        return "\(self.replyPosts.count)"
    }
    
    var shoudHideReplyedButton: Bool {
        return self.replyPosts.count == 0
    }
    
    
    init(model: PostModel, thread: String) {
        self.uid = model.uid
        self.media = model.files
        self.modifier = PostPreparation(text: model.comment, thread: thread, post: model.uid)
        
        let date = Date(timeIntervalSince1970: model.date)

        self.name = model.name
        self.number = model.number
        self.date = String.date(from: date)
    }
    
    func calculateSize(max width: CGFloat) {
        let textSize = TextSize(text: self.text.string, maxWidth: width, font: UIFont.text, lineHeight: UIFont.text.lineHeight)
        let textHeight = textSize.calculate().height
        
        let titleHeight = TextSize(text: self.title.string, maxWidth: CGFloat.infinity, font: UIFont.postTitle, lineHeight: UIFont.postTitle.lineHeight).calculate().height
        
        self.titleHeight = titleHeight
        self.textHeight = textHeight
        
        var resultHeight = PostTitleTopMargin + titleHeight + PostTitleTextMargin + textHeight + PostTextBottomMargin
        if !self.shoudHideReplyedButton {
            resultHeight += PostBottomHeight
        }
        
        self.height = resultHeight
    }
    
    func reset() {
        self.heightCalculated = false
        self.titleHeight = 0
        self.textHeight = 0
        self.height = 0
    }
    
    

}
