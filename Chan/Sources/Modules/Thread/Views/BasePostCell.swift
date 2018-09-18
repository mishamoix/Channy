//
//  BasePostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol BasePostCellProtocol {
    func update(with model: PostViewModel)
}

class BasePostCell: UICollectionViewCell, BasePostCellProtocol {
    
    private let titleLabel = TGReusableLabel()
    private let replyedButton = UIButton()
    let disposeBag = DisposeBag()
    
    weak var action: PublishSubject<PostCellAction>?

    
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
        
        self.contentView.addSubview(self.replyedButton)
        self.replyedButton.layer.cornerRadius = DefaultCornerRadius
        self.replyedButton.layer.borderColor = UIColor.main.cgColor
        self.replyedButton.layer.borderWidth = 1
        self.replyedButton.setTitleColor(.main, for: .normal)
        self.replyedButton.titleLabel?.font = UIFont.postTitle
        
        self.replyedButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PostButtonRightMargin)
            make.bottom.equalToSuperview().offset(-PostButtonBottomMargin)
            make.size.equalTo(PostButtonSize)
        }
        
        self.replyedButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                if let strongSelf = self {
                    self?.action?.on(.next(.openReplys(cell: strongSelf)))
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    func update(with model: PostViewModel) {
        self.titleLabel.attributedText = model.title
        self.titleLabel.frame = CGRect(x: PostTitleLeftMargin, y: PostTitleTopMargin, width: self.frame.width - (PostTitleLeftMargin + PostTitleRightMargin), height: model.titleHeight)
        self.titleLabel.setNeedsDisplay()
        
        self.replyedButton.isHidden = model.shoudHideReplyedButton
        self.replyedButton.setTitle(model.replyedButtonText, for: .normal)
    }
    
}
