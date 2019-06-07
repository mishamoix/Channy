//
//  PostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PostCell: BasePostCell {
    
//    private let textLabel = TGReusableLabel()
//    private let textLabel = UILabel()

    private let textLabel = UITextView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupRx()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
      
//        self.textLabel.numberOfLines = 0
        self.textLabel.textContainer.lineFragmentPadding = 0
        self.textLabel.textContainerInset = .zero
        self.textLabel.isScrollEnabled = false
        self.textLabel.isEditable = false
        self.contentView.addSubview(self.textLabel)
        self.textLabel.backgroundColor = .clear
//
    }
    
    override func update(with model: PostViewModel) {
        super.update(with: model)
        
//        self.textLabel.isScrollEnabled = true
        
        self.textLabel.attributedText = model.text
        self.textLabel.frame = model.textFrame
      
//        self.textLabel.sizeToFit()
//        self.textLabel.setNeedsDisplay()
        

        
    }
    
    private func setupRx() {
        let tap = UITapGestureRecognizer()
        self.textLabel.isUserInteractionEnabled = true
        self.textLabel.addGestureRecognizer(tap)

        tap
            .rx
            .event
            .asDriver()
            .drive(onNext: { [weak self] recognizer in
                if let textLabel = self?.textLabel, let strongSelf = self {
                    let point = recognizer.location(in: textLabel)
                    let idx = TextSize.indexForPoint(text: textLabel.attributedText, point: point, container: textLabel.bounds.size)


                    self?.textLabel.attributedText?.enumerateAttribute(NSAttributedString.Key.reply, in: NSRange(location: idx, length: 1), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (result, range, stop) in
                        if let reply = result as? String {
                            self?.action?.on(.next(.openPostReply(reply: reply, cell: strongSelf)))
                            return
                        }
                    }
                    self?.textLabel.attributedText?.enumerateAttribute(NSAttributedString.Key.chanlink, in: NSRange(location: idx, length: 1), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (result, range, stop) in
                            if let link = result as? URL {
                                self?.action?.on(.next(.tappedAtLink(url: link, cell: strongSelf)))
                                return
                            }
                    }
                }
            }).disposed(by: self.disposeBag)
        

    }
    
    
    


}
