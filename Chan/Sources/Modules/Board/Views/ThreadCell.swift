//
//  ThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa



class ThreadCell: SwipeCollectionViewCell {

    
    @IBOutlet weak var canvas: ChanView!
    @IBOutlet weak var iconView: ChanImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var newPosts: UILabel!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var starred: UIButton!
    
    private var title: UILabel = UILabel()
    private var message: UILabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    weak var actions: PublishSubject<BoardCellAction>? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.canvas.layer.cornerRadius = ThreadCellCornerRadius
//        self.canvas.clipsToBounds = true
//
//        self.canvas.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//        self.canvas.layer.borderWidth = 1
        
        self.iconView.clipsToBounds = true
        self.iconView.layer.cornerRadius = ImageCornerRadius
        
        self.canvas.addSubview(self.message)
        self.message.numberOfLines = 0
        self.message.font = .text

        
        self.canvas.addSubview(self.title)
        self.title.numberOfLines = 0
        self.title.font = .postTitle
        
//        self.message.snp.makeConstraints { make in
//            make.left.equalTo(self.iconView.snp.right).offset(MediumMargin)
//            make.right.equalToSuperview().offset(-MediumMargin)
//
//            make.top.equalToSuperview().offset(DefaultMargin)
//            make.bottom.equalToSuperview().offset(-DefaultMargin)
//        }
        
//        self.canvas.setupLongGesture()
        
        let tapOnCell = UITapGestureRecognizer()
        self.canvas.addGestureRecognizer(tapOnCell)
        self.canvas.isUserInteractionEnabled = true
        
        tapOnCell.rx.event
            .asDriver()
            .drive(onNext: { [weak self] gesture in
                if let strongSelf = self {
                    strongSelf.actions?.on(.next(.tapped(cell: strongSelf)))
                }
            }).disposed(by: self.disposeBag)
//        
//        self.canvas.backgroundColor = .snow
        
        self.starred
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions?.on(.next(.starTapped(cell: self)))
            })
            .disposed(by: self.disposeBag)
        
        self.setupTheme()
        
//        self.actionsView?.backgroudColor = .clear
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.message.setNeedsDisplay()
    }
    
    func update(with model: ThreadViewModel) {
//        super.update(with: model)
        
        self.title.text = model.title

        Helper.performOnMainThread {
            self.message.attributedText = model.comment
            self.iconView.loadImage(media: model.media)
        }
        
        let textRightOffset = ThreadImageLeftMargin + ThreadImageSize + ThreadImageTextMargin
        
        self.title.frame = CGRect(x: textRightOffset, y: ThreadTopMargin, width: model.titleSize.width, height: model.titleSize.height)
        self.message.frame = CGRect(x: textRightOffset, y: ThreadTopMargin + model.titleSize.height + ThreadTitleMessageMargin, width: model.messageSize.width, height: model.messageSize.height)
        
        
        if model.favorited {
            self.starred.setImage(.fullStar, for: .normal)
        } else {
            self.starred.setImage(.star, for: .normal)
//            self.starred.image = .star
        }
        
//        self.starred.isHidden = true
        self.newPosts.isHidden = true
        
        self.postsCount.text = String(model.postsCount)
        self.number.text = String(model.number)
      
    }
    
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self.canvas, type: .cell, subtype: .border))
//        ThemeManager.shared.append(view: ThemeView(view: self.message, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.number, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.postsCount, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.newPosts, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.commentsImage, type: .icon, subtype: .accent))


        self.backgroundColor = .clear

    }
    

    

    
    
    
    
    
}
