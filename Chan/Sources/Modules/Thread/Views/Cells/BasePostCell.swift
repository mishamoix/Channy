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
    func update(action: PublishSubject<PostCellAction>?)
}

class BasePostCell: UICollectionViewCell, BasePostCellProtocol {
    
    private let titleLabel = TGReusableLabel()
    private let replyedButton = UIButton()
    let disposeBag = DisposeBag()
    
    var canPerformAction: Bool = true
        
    weak var action: PublishSubject<PostCellAction>?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.canPerformAction = true
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
        self.replyedButton.layer.borderColor = ThemeManager.shared.theme.main.cgColor
        self.replyedButton.layer.borderWidth = 1
        self.replyedButton.setTitleColor(ThemeManager.shared.theme.main, for: .normal)
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
        
        self.setupTheme()
        
    }
    
    func update(with model: PostViewModel) {
        self.titleLabel.attributedText = model.title
        self.titleLabel.frame = model.titleFrame
        self.titleLabel.setNeedsDisplay()
        
        self.replyedButton.isHidden = model.shoudHideReplyedButton
        self.replyedButton.setTitle(model.replyedButtonText, for: .normal)
    }
    
    func update(action: PublishSubject<PostCellAction>?) {
        self.action = action
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    self.themeManager.append(view: ThemeView(view: self.collectionView, type: .collection, subtype: .none))

    func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .border))
//        ThemeManager.shared.append(view: ThemeView(view: self.contentView, type: .cell, subtype: .border))

//        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .none))
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return self.canPerformAction && ThreadAvailableContextMenu.contains(action.description) 
    }
    
    
    @objc public func copyText() {
        self.action?.on(.next(.copyText(cell: self)))
    }
    
    @objc public func copyOrigianlText() {
        self.action?.on(.next(.copyOriginalText(cell: self)))
    }
}
