//
//  ChanImageView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift

class ChanImageView: UIImageView {
  
    private var firstTime = true
    let manager = CensorImageManager()
    private let disposeBag = DisposeBag()
    
    func loadImage(media: MediaModel?, full: Bool = false, enable censor: Bool = true) {
        
        guard let model = media else {
            return
        }
        self.configureIfNeeded()
        self.manager.full = full
        self.manager.censorEnabled = censor
        self.manager.load(media: model)
    }

    
    func cancelLoad() {
        self.manager.cancel()
    }
    
    func configureIfNeeded() {
        if self.firstTime {
            self.firstTime = false
            
            self.manager
                .image
                .asObservable()
                .observeOn(Helper.rxMainThread)
                .subscribe(onNext: {[weak self] image in
                    self?.image = image
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    
}
