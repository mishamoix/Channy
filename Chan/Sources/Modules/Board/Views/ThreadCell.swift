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


class ThreadCell: UICollectionViewCell {

    @IBOutlet weak var canvas: ChanView!
    @IBOutlet weak var iconView: ChanImageView!
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
        
//        self.setupTheme()
        
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
        
        self.message.text = model.displayText
        self.title.text = model.title
//        self.message.textColor = .black
//        self.message.backgroundColor = .clear
        
//        self.message.setNeedsDisplay()
        

        self.iconView.cancelLoad()
        self.iconView.image = nil
        if let thumbnail = model.thumbnail {
            self.iconView.load(url: thumbnail)
            self.iconView.censor(file: model.file)
//            self.iconView.af_setImage(withURL: thumbnail)
        }
        
        let textRightOffset = ThreadImageLeftMargin + ThreadImageSize + ThreadImageTextMargin
        
        self.title.frame = CGRect(x: textRightOffset, y: ThreadTopMargin, width: model.titleSize.width, height: model.titleSize.height)
        self.message.frame = CGRect(x: textRightOffset, y: ThreadTopMargin + model.titleSize.height + ThreadTitleMessageMargin, width: model.messageSize.width, height: model.messageSize.height)
      
    }
    
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self.canvas, type: .cell, subtype: .border))
        ThemeManager.shared.append(view: ThemeView(view: self.message, type: .text, subtype: .none))
      
        self.backgroundColor = .clear

    }
    

    

    
    
    
    
    
}
