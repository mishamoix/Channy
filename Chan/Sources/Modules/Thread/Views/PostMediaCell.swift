//
//  PostMediaCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 20.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class PostMediaCell: PostCell {
    private var firstImage: ChanImageView = ChanImageView()
    private var secondImage: ChanImageView = ChanImageView()
    private var thirdImage: ChanImageView = ChanImageView()
    private var forthImage: ChanImageView = ChanImageView()
    
    private var images: [ChanImageView] {
        return [firstImage, secondImage, thirdImage, forthImage]
    }
    
    private var isFirst = true

    override func setupUI() {
        super.setupUI()
        
        self.prepare(image: self.firstImage)
        self.prepare(image: self.secondImage)
        self.prepare(image: self.thirdImage)
        self.prepare(image: self.forthImage)
    }
    
    override func update(with model: PostViewModel) {
        super.update(with: model)
        self.setupConstrainst(with: model)
        
        let _ = self.images.map { $0.af_cancelImageRequest() }
        let _ = self.images.map { $0.isHidden = true }
        
        for (idx, media) in model.media.enumerated() {
            if self.images.count > idx {
                if let thumb = URL(string: MakeFullPath(path: media.thumbnail)) {
                    let img = self.images[idx]
                    img.af_setImage(withURL: thumb)
                    img.isHidden = false
                }
            }
        }
    }
    
    // MARK: Private
    private func prepare(image: UIView) {
        self.contentView.addSubview(image)
        image.isHidden = true
        image.clipsToBounds = true
        image.layer.cornerRadius = DefaultCornerRadius
        image.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer()
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        tap.rx
            .event
            .asDriver()
            .drive(onNext: { [weak self] gesture in
                if let view = gesture.view as? ChanImageView, let idx = self?.images.firstIndex(of: view), let strongSelf = self {
                    self?.action?.on(.next(.openMedia(idx: idx, cell: strongSelf, view: view)))
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupConstrainst(with model: PostViewModel) {
        if (self.isFirst) {
            self.isFirst = false
            
            self.firstImage.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(model.mediaFrame.minY)
                make.left.equalToSuperview().offset(PostMediaMargin)
                make.width.equalTo(model.mediaFrame.width)
                make.height.equalTo(model.mediaFrame.height)
            }
            
            self.secondImage.snp.makeConstraints { (make) in
                make.top.equalTo(self.firstImage)
                make.left.equalTo(self.firstImage.snp.right).offset(PostMediaMargin)
                make.width.equalTo(model.mediaFrame.width)
                make.height.equalTo(model.mediaFrame.height)
            }
            
            self.thirdImage.snp.makeConstraints { (make) in
                make.top.equalTo(self.secondImage)
                make.left.equalTo(self.secondImage.snp.right).offset(PostMediaMargin)
                make.width.equalTo(model.mediaFrame.width)
                make.height.equalTo(model.mediaFrame.height)
            }
            
            self.forthImage.snp.makeConstraints { (make) in
                make.top.equalTo(self.thirdImage)
                make.left.equalTo(self.thirdImage.snp.right).offset(PostMediaMargin)
                make.width.equalTo(model.mediaFrame.width)
                make.height.equalTo(model.mediaFrame.height)
            }
            
            self.layoutSubviews()
        }
    }
    
}
