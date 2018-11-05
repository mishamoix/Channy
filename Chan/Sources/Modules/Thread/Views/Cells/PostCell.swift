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
    
    private let textLabel = TGReusableLabel()
//    private let textLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupUI() {
        super.setupUI()
      
        self.textLabel.numberOfLines = 0
        
        self.contentView.addSubview(self.textLabel)
        self.textLabel.backgroundColor = .clear
        
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
                    
                    
                  self?.textLabel.attributedText?.enumerateAttribute(NSAttributedString.Key.chanlink, in: NSRange(location: idx, length: 1), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (result, range, stop) in
                        if let link = result as? URL {
                            self?.action?.on(.next(.tappedAtLink(url: link, cell: strongSelf)))
                        }
                    }
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    override func update(with model: PostViewModel) {
        super.update(with: model)
        
        self.textLabel.attributedText = model.text
        self.textLabel.frame = model.textFrame
        
        self.textLabel.setNeedsDisplay()
    }
    


}
