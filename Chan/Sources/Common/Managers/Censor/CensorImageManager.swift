//
//  CensorImageManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage


enum CensorImageManagerType {
    case normal
    case placeholder
}

class CensorImageManager {
    // tokens
    private(set) var disposeBag = DisposeBag()
    private(set) var blurDisposeBag = DisposeBag()
    
    private(set) var cancellation = CancellationToken()
    private var loadToken: RequestReceipt? = nil

    // data
    private var media: MediaModel?
    var full: Bool = false
    var censorEnabled: Bool = true
    
    // inner
    private var needCensor = true
    let image = Variable<UIImage?>(nil)
    private var originalImage: UIImage? = nil
    private var type: CensorImageManagerType = .placeholder
    private var loaderUrl: String? = nil
    
    private var loader: ChanImageDownloader {
        return ChanImageDownloader.shared
    }
    
    init() {}
    
    
    
    func cancel() {
        self.disposeBag = DisposeBag()
        self.blurDisposeBag = DisposeBag()
        self.cancellation.isCancelled = true
        self.cancellation = CancellationToken()
        self.loader.cancel(token: self.loadToken)
        self.loadToken = nil
        self.loaderUrl = nil
        self.originalImage = nil
        self.needCensor = true

    }
    
    func load(media: MediaModel) {
        self.cancel()
        self.media = media
        self.runCensor()
        self.runLoadImage()
    }
    
    
    private func runCensor() {
        if Values.shared.safeMode {
            self.update(need: true)
            return
        }
        if self.censorEnabled {
            self.update(need: true)
        }
        if let url = self.media?.url {
            CensorManager.shared
                .censor(url: url.absoluteString)
                .subscribe(onNext: { [weak self] censor in
                    self?.update(need: censor)
                })
                .disposed(by: self.disposeBag)
        }
    }

    
    private func runLoadImage() {
        guard let media = self.media else { return }
        
        let url = self.full ? media.url ?? media.thumbnail : media.thumbnail ?? media.url
        self.loaderUrl = url?.absoluteString
        
        if let url: URL = (url) {
            if let img = self.loader.checkCache(url: url) {
                self.originalImage = img
                self.type = .normal
                self.updateImage()
                return
            } else {
                self.originalImage = UIImage.placeholder
                self.type = .placeholder
                self.updateImage()
            }
            
            self.loadToken = self.loader.load(url: url) { [weak self] result in
                switch result.result {
                case .success(let img):
                    self?.originalImage = img
                    self?.type = .normal
                    self?.updateImage()
                default:
                    break
                }
            }
        }
    }
    
    private func update(need censor: Bool) {
        if self.needCensor != censor {
            self.needCensor = censor
            self.updateImage()
        }
    }
    
    private func updateImage() {
        if self.type == .placeholder {
            self.setup(image: self.originalImage)
        } else {
            if let image = self.originalImage, let url = self.loaderUrl, self.needCensor {
                if let img = CensorCacheManager.shared.cached(path: url) {
                    self.setup(image: img)
                } else {
                    self.setup(image: .placeholder)
                    CensorCacheManager
                        .shared
                        .censored(image: image, path: url)
                        .debug()
                        .subscribe(onNext: {[weak self] image in
                            self?.setup(image: image)
                        })
                        .disposed(by: self.blurDisposeBag)
                    
                }
                return

            }
            
            self.blurDisposeBag = DisposeBag()
            self.setup(image: self.originalImage)
            
        }
    }
    
    private func setup(image: UIImage?) {
        if let img = image {
            self.image.value = img
        } else if self.image.value != nil && image == nil {
            self.image.value = nil
        }
    }
    
}
