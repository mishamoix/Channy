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
    private var firstImage = PostMediaView()
    private var secondImage = PostMediaView()
    private var thirdImage = PostMediaView()
    private var forthImage = PostMediaView()
    
    private var images: [PostMediaView] {
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
        
        let _ = self.images.map { $0.cancelLoad() }
        let _ = self.images.map { $0.isHidden = true }
                
        for (idx, media) in model.media.enumerated() {
            if idx < self.images.count {
                let imgView = self.images[idx]
                imgView.update(with: media)
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
                if let view = gesture.view as? PostMediaView, let idx = self?.images.firstIndex(of: view), let strongSelf = self {
                    self?.action?.on(.next(.openMedia(idx: idx, cell: strongSelf, view: view.image)))
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupConstrainst(with model: PostViewModel) {
        
        self.firstImage.frame = CGRect(x: PostMediaMargin, y: model.mediaFrame.minY, width: model.mediaFrame.width, height: model.mediaFrame.height)
        self.secondImage.frame = CGRect(x: self.firstImage.frame.maxX + PostMediaMargin, y: self.firstImage.frame.minY, width: model.mediaFrame.width, height: model.mediaFrame.height)
        self.thirdImage.frame = CGRect(x: self.secondImage.frame.maxX + PostMediaMargin, y: self.firstImage.frame.minY, width: model.mediaFrame.width, height: model.mediaFrame.height)
        self.forthImage.frame = CGRect(x: self.thirdImage.frame.maxX + PostMediaMargin, y: self.firstImage.frame.minY, width: model.mediaFrame.width, height: model.mediaFrame.height)
    }
    
}
