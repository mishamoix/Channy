//
//  ChanFullImageLoader.swift
//  Chan
//
//  Created by Mikhail Malyshev on 13/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift


class ChanFullImageLoader: NSObject, AXNetworkIntegrationProtocol {
    
    private var imageDownloader: ImageDownloader {
        return ChanImageDownloader.shared.fullImageLoader
    }
    
    private let disposeBag = DisposeBag()
    
    
    private let requests: [URLRequest] = []
    
    
    var delegate: AXNetworkIntegrationDelegate?
    
    func loadPhoto(_ photo: AXPhotoProtocol) {
        
        if let model = photo as? AXChanImage {
            
            self.process(model: model)
                .subscribe(onNext: { [weak self] model in
                    guard let self = self else { return }
                    self.delegate?.networkIntegration(self, loadDidFinishWith: model)
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    self.delegate?.networkIntegration(self, loadDidFailWith: error, for: model)
                }).disposed(by: self.disposeBag)
            
        } else {
            self.delegate?.networkIntegration(self, loadDidFailWith: ChanError.noModel, for: photo)
        }
   
    }
    
    
    
    private func process(model: AXChanImage) -> Observable<AXChanImage> {
        return self
            .load(model: model)
            .flatMap({ [weak self] model -> Observable<AXChanImage> in
                guard let self = self else { return Observable<AXChanImage>.just(model) }
                return self.blurIfNeeded(model: model)
            })
        
        
    }
    
    private func load(model: AXChanImage) -> Observable<AXChanImage> {
        
        return Observable<AXChanImage>.create { observable -> Disposable in
            
            if let img = self.imageDownloader.imageCache?.image(withIdentifier: model.path) {
                model.update(original: img)
                observable.on(.next(model))
                observable.on(.completed)
            } else {
                let request = URLRequest(url: model._url)
                model.cancelable = self.imageDownloader.download(request) { response in
                    switch response.result {
                    case .success(let img):
                        model.update(original: img)
                    case .failure(let error):
                        return observable.on(.error(error))
                    }
                    
                    observable.on(.next(model))
                    observable.on(.completed)

                }
            }

            return Disposables.create {
                if let cancel = model.cancelable {
                    self.imageDownloader.cancelRequest(with: cancel)
                }
            }
        }
        
    }
    
    private func blurIfNeeded(model: AXChanImage) -> Observable<AXChanImage> {
        
        guard let image = model.originalImage, model.needBlur || Values.shared.safeMode else {
            return Observable<AXChanImage>.just(model)
        }
        
        if let img = CensorCacheManager.shared.cached(path: model.path) {
            model.update(blurred: img)
            return Observable<AXChanImage>.just(model)
        } else {
        
            return CensorCacheManager.shared
                .censored(image: image, path: model.path)
                .asObservable()
                .flatMap({ image -> Observable<AXChanImage> in
                    model.update(blurred: image)
                    return Observable<AXChanImage>.just(model)
                })
        }
        
    }
    
    func origianl(for photo: AXPhotoProtocol) -> UIImage? {
        if let model = photo as? AXChanImage {
            return model.originalImage
        }
        return nil
    }
    

    func cancelLoad(for photo: AXPhotoProtocol) {
        if let model = photo as? AXChanImage, let cancel = model.cancelable {
            self.imageDownloader.cancelRequest(with: cancel)
        }
    }
    
    func cancelAllLoads() {
//        self.imageDownloader.ca
        //        let _ = self.requests.map({ self.imageDownloader.cancelRequest(with: $0) })
        //        self.requests = []
    }
        
}
