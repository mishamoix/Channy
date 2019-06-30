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
    private let censorWorkingView = UIImageView(image: .sandWatch)
    
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
    
    private func updateShowCensor(working: Bool) {
        
        self.censorWorkingView.layer.removeAllAnimations()
        
        if working && self.censorWorkingView.isHidden {
            self.censorWorkingView.alpha = 0
            self.censorWorkingView.isHidden = false
            
            UIView.animate(withDuration: AnimationDuration) {
                self.censorWorkingView.alpha = 1
            }
        } else if !working && !self.censorWorkingView.isHidden {
            self.censorWorkingView.alpha = 1
            self.censorWorkingView.isHidden = false
            
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.censorWorkingView.alpha = 0
            }) { completed in
                self.censorWorkingView.isHidden = true
            }

        }
        
        self.censorWorkingView.isHidden = !working
    }
    
    func configureIfNeeded() {
        if self.firstTime {
            self.firstTime = false
            
            let offset: CGFloat = 6
            
            self.addSubview(self.censorWorkingView)
            self.censorWorkingView.frame = CGRect(x: offset, y: offset, width: SendWatchSize, height: SendWatchSize)
            
            self.censorWorkingView.tintColor = ThemeManager.shared.theme.accnt
            
            self.manager
                .image
                .asObservable()
                .observeOn(Helper.rxMainThread)
                .subscribe(onNext: {[weak self] image in
                    self?.image = image
                })
                .disposed(by: self.disposeBag)
            
            self.manager
                .censorWorkingObservable
                .asObservable()
                .debounce(0.5, scheduler: Helper.rxMainThread)
                .subscribe(onNext: { [weak self] working in
                    self?.updateShowCensor(working: working)
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    
}
