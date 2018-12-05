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


class ThreadCell: BaseTableViewCell<ThreadViewModel> {

    @IBOutlet weak var canvas: ChanView!
    @IBOutlet weak var iconView: ChanImageView!
    private var message: TGReusableLabel = TGReusableLabel(frame: .zero)
    private let disposeBag = DisposeBag()
    
    weak var actions: PublishSubject<BoardCellAction>? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.canvas.layer.cornerRadius = ThreadCellCornerRadius
        self.canvas.clipsToBounds = true
        
        self.canvas.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.canvas.layer.borderWidth = 1
        
        self.iconView.clipsToBounds = true
        
        self.canvas.addSubview(self.message)
        
        self.message.snp.makeConstraints { make in
            make.left.equalTo(self.iconView.snp.right).offset(MediumMargin)
            make.right.equalToSuperview().offset(-MediumMargin)
            
            make.top.equalToSuperview().offset(DefaultMargin)
            make.bottom.equalToSuperview().offset(-DefaultMargin)
        }
        
//        self.canvas.setupLongGesture()
        
//        let tapOnCell = UITapGestureRecognizer()
//        self.canvas.addGestureRecognizer(tapOnCell)
//        self.canvas.isUserInteractionEnabled = true
        
//        tapOnCell.rx.event
//            .asDriver()
//            .drive(onNext: { [weak self] gesture in
//                if let strongSelf = self {
//                    strongSelf.actions?.on(.next(.tapped(cell: strongSelf)))
//                }
//            }).disposed(by: self.disposeBag)
//        
        self.canvas.backgroundColor = .snow
        
        self.setupTheme()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.message.setNeedsDisplay()
    }
    
    override func update(with model: ThreadViewModel) {
        super.update(with: model)
        
        self.message.text = model.displayText
        self.message.font = .text
//        self.message.textColor = .black
        self.message.backgroundColor = .clear
        
        self.message.setNeedsDisplay()
        

        self.iconView.cancelLoad()
        self.iconView.image = nil
        if let thumbnail = model.thumbnail {
            self.iconView.load(url: thumbnail)
            self.iconView.censor(file: model.file)
//            self.iconView.af_setImage(withURL: thumbnail)
        }
      
    }
    
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self.canvas, type: .cell, subtype: .border))
        ThemeManager.shared.append(view: ThemeView(view: self.message, type: .text, subtype: .none))
      
        self.backgroundColor = .clear

    }
    

    

    
    
    
    
    
}
