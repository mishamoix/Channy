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
  
    @IBInspectable var needCensor: Bool = true
    
    private var originalImage: UIImage? = nil
//    private var blurredImage: UIImage? = nil
    private(set) var disposeBag = DisposeBag()
    
    private(set) var cancellation = CancellationToken()
    var isCensored: Bool? = nil {
        didSet {
            if let needCensor = self.isCensored, !needCensor {
                if !needCensor {
                    self.setOriginal()
                }
            }
        }
    }
    
    override var image: UIImage? {
        set {
          #if REALESE
                Helper.performOnMainThread {
                    if Values.shared.censorEnabled && (self.isCensored ?? true) && self.needCensor {
                        self.originalImage = newValue
                        
                        Helper.performOnBGThread {
                            let newImage = newValue?.applyBlur(percent: BlurRadiusPreview)
                            Helper.performOnMainThread {
                                if !self.cancellation.isCancelled {
                                    super.image = newImage
                                }
                            }
                    
                        }
                    } else {
                        super.image = newValue
                    }
                }
          #else
            super.image = newValue
          #endif
        }
        
        get {
            return super.image
        }
    }
    
    
    private func setOriginal() {
        if self.originalImage != nil {
            Helper.performOnMainThread {
                
                self.image = self.originalImage
            }
        }

    }
//
    
    func load(url: URL?) {
        self.isCensored = nil
        self.image = nil
        self.originalImage = nil
        self.cancelLoad()
        
        if !FirebaseManager.shared.disableImages {
            if let url = url {
//                self.af_setImage(withURL: url) { (response: DataResponse<UIImage>) in
//
//                }
                self.af_setImage(withURL: url)
            }
        } else {
            self.image = UIImage(color: .black, size: CGSize(width: 1, height: 1))
        }
    }
    
    func loadImage(media: MediaModel?) {
        self.cancelLoad()
        
        guard let model = media else {
            return
        }
        
        self.censor(media: media)
        
        self.image = UIImage.placeholder
        if let url: URL = (model.thumbnail ?? model.url) {
            self.af_setImage(withURL: url)
        }
        
    }
    
    func censor(media: MediaModel?) {
        if self.needCensor && Values.shared.censorEnabled {
            self.dispose()
            if let media = media {
//                self.cen
//                let path = CensorManager.path(for: media)
//                self.censor(path: path)
            }
        }
    }
    
    func cancelLoad() {
        self.af_cancelImageRequest()
        self.dispose()
        self.cancellation.isCancelled = true
        self.cancellation = CancellationToken()
    }
    
    private func dispose() {
        self.disposeBag = DisposeBag()
    }
    
    
}
