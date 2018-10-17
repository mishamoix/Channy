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
    
    private let date: String
    private let name: String
    private let number: Int
    
    private(set) var height: CGFloat = 0
    private(set) var titleFrame: CGRect = .zero
    private(set) var textFrame: CGRect = .zero
    private(set) var mediaFrame: CGRect = .zero
    private(set) var bottomFrame: CGRect = .zero
    
//    private(set) var textFrame: CGFloat = 0
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
        
        print("Inited PostVM \(model.number)")
    }
    
    func calculateSize(max width: CGFloat) {
        
        let maxTextWidth = width - (PostTextLeftMargin + PostTextRightMargin)
        
        let textSize = TextSize(text: self.text.string, maxWidth: maxTextWidth, font: UIFont.text, lineHeight: UIFont.text.lineHeight)
        let textHeight = textSize.calculate().height
        
        let titleHeight = TextSize(text: self.title.string, maxWidth: CGFloat.infinity, font: UIFont.postTitle, lineHeight: UIFont.postTitle.lineHeight).calculate().height

        let headerSection: CGFloat = PostTitleTopMargin + titleHeight
        var mediaSection: CGFloat = 0
        let textSection: CGFloat = PostTextTopMargin + textHeight
        var bottomSection: CGFloat = 0
        
        var mediaWidthHeight: CGFloat = 0
        
        if self.media.count != 0 {
            mediaWidthHeight = (width - 5 * PostMediaMargin) / 4
            mediaSection = PostMediaTopMargin + mediaWidthHeight
        }
        
        if !self.shoudHideReplyedButton {
            bottomSection += PostButtonTopMargin + PostBottomHeight
        } else {
            bottomSection = PostTextBottomMargin
        }

        self.titleFrame = CGRect(x: PostTitleLeftMargin, y: PostTitleTopMargin, width: width - (PostTitleLeftMargin + PostTitleRightMargin), height: titleHeight)
        self.mediaFrame = CGRect(x: PostMediaMargin, y: headerSection + PostMediaTopMargin, width: mediaWidthHeight, height: mediaWidthHeight)
        
        self.textFrame = CGRect(x: PostTextLeftMargin, y: headerSection + mediaSection + PostTextTopMargin, width: width - PostTextLeftMargin - PostTextRightMargin, height: textHeight)
        self.bottomFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let resultHeight = headerSection + mediaSection + textSection + bottomSection
        self.height = resultHeight
    }
    
    func reset() {
        self.heightCalculated = false
        self.titleFrame = .zero
        self.textFrame = .zero
        self.mediaFrame = .zero
        self.bottomFrame = .zero
        
        self.height = 0
    }
    
    func tag(for idx: Int) -> TagViewModel? {
        return self.modifier.tags.filter({ $0.isIdxInRange(idx) }).first
    }
    
    

}
