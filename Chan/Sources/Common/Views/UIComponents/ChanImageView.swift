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
    
    private(set) var cancellation = CancellationToken()
    var isCensored: Bool = false {
        willSet {
            if newValue && self.image != nil {
                Helper.performOnMainThread {
                    self.image = self.image?.applyBlur(radius: 5)
                }
            }
        }
    }
    
    override var image: UIImage? {
        willSet {
            if self.isCensored && self.image == nil && newValue != nil {
                Helper.performOnMainThread {
                    self.image = self.image?.applyBlur(radius: 5)
                }
            }
        }
    }
    
    
    func load(url: URL?) {
        self.isCensored = false
        self.cancelCensor()
        self.image = nil
        
        if !Values.shared.safeMode && !FirebaseManager.shared.disableImages {
            if let url = url {
                self.cancelLoad()
                self.af_setImage(withURL: url)
                self.censor(path: url.absoluteString)

            }
        } else {
            self.image = UIImage(color: .black, size: CGSize(width: 1, height: 1))
        }
    }
    func cancelLoad() {
        self.af_cancelImageRequest()
    }
    
    func dispose() {
        self.cancellation.isCancelled = true
        self.cancellation = CancellationToken()
    }
    
    
}
