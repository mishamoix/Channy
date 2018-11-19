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
    
    private var originalImage: UIImage? = nil
    private(set) var disposeBag = DisposeBag()
    
    private(set) var cancellation = CancellationToken()
    var isCensored: Bool? = nil {
        didSet {
            if let needCensor = self.isCensored {
                if !needCensor {
                    self.setOriginal()
                }
            }
        }
    }
    
    override var image: UIImage? {
        set {
                Helper.performOnMainThread {
                    if Values.shared.censorEnabled && (self.isCensored ?? true) {
                        self.originalImage = newValue
                        super.image = newValue?.applyBlur(radius: 5)
                    } else {
                        super.image = newValue
                    }
                }
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
    
    func censor(file: FileModel?) {
        self.dispose()
        if let file = file {
            if Values.shared.censorEnabled {
                let path = CensorManager.path(for: file)
                self.censor(path: path)
            }
        }
    }
    
    func cancelLoad() {
        self.af_cancelImageRequest()
        self.dispose()
    }
    
    private func dispose() {
        self.disposeBag = DisposeBag()
    }
    
    
}
