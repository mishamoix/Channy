//
//  BasePostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit

protocol BasePostCellProtocol {
    func update(with model: PostViewModel)
}

class BasePostCell: UICollectionViewCell, BasePostCellProtocol {
    
    private let titleLabel = TGReusableLabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.borderWidth = 1
        
        self.clipsToBounds = true
        self.layer.cornerRadius = DefaultCornerRadius
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.backgroundColor = .clear
    }
    
    func update(with model: PostViewModel) {
        self.titleLabel.attributedText = model.title
        self.titleLabel.frame = CGRect(x: PostTitleLeftMargin, y: PostTitleTopMargin, width: self.frame.width - (PostTitleLeftMargin + PostTitleRightMargin), height: model.titleHeight)
        self.titleLabel.setNeedsDisplay()
    }
    
}
