//
//  PostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PostCell: BasePostCell {
    
    private let textLabel = TGReusableLabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.contentView.addSubview(self.textLabel)
        self.textLabel.backgroundColor = .clear
        
    }
    
    override func update(with model: PostViewModel) {
        super.update(with: model)
        
        self.textLabel.attributedText = model.text
        self.textLabel.frame = CGRect(x: PostTextLeftMargin, y: self.caclulateTextMargin(with: model), width: self.frame.width - PostTextLeftMargin - PostTextRightMargin, height: model.textHeight)
        
        self.textLabel.setNeedsDisplay()
    }
    
    
    func caclulateTextMargin(with model: PostViewModel) -> CGFloat {
        return self.frame.height - (PostTextBottomMargin + model.textHeight)
    }

}
