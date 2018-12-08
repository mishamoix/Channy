//
//  ThreadImageViewer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AXPhotoViewer
import AlamofireImage


class ImageNetworkIntegration: NSObject, AXNetworkIntegrationProtocol {
  
    private static let cache = AutoPurgingImageCache()

    private static let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .lifo,
        maximumActiveDownloads: 4,
        imageCache: ImageNetworkIntegration.cache
    )
  
  
    private let requests: [URLRequest] = []

    
    var delegate: AXNetworkIntegrationDelegate?
    
    func loadPhoto(_ photo: AXPhotoProtocol) {
        if let url = photo.url {
            let request = URLRequest(url: url)

            self.image(for: request) { [weak self, weak photo] image in
                if let img = image {
                    if let photo = photo, let self = self {
                        photo.image = img
                        self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                    }
                    
                    return

                }
                
                ImageNetworkIntegration.imageDownloader.download([request], filter: nil, progress: { [weak self, weak photo] progress in
                    guard let self = self, let photo = photo else {
                        return
                    }
                    
                    
                    self.delegate?.networkIntegration?(self, didUpdateLoadingProgress: CGFloat(progress.fractionCompleted), for: photo)
                }, progressQueue: DispatchQueue.main) { [weak self, weak photo] response in
                    
                    if let image = ImageFixer.fixIfNeeded(image: response.data) {
                        ImageNetworkIntegration.cache.add(image, for: request)
                        
                        
                        self?.image(for: request, callBack: { [weak self, weak photo] image in
                            if let photo = photo, let self = self {
                                photo.image = image
                                self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                            } else {
                                print("not catched")
                            }
                        })
                        
                    } else if let self = self, let photo = photo {
                        self.delegate?.networkIntegration(self, loadDidFailWith: response.error ?? ChanError.badRequest, for: photo)
                    }
                }
            }
            

        }
    }
    
    @objc func origianl(for photo: AXPhotoProtocol) -> UIImage? {
        if let url = photo.url {
            let request = URLRequest(url: url)
            return ImageNetworkIntegration.cache.image(for: request)
        }
        
        return nil
    }
    
    func image(for request: URLRequest, callBack: @escaping (UIImage?) -> ()){
        guard let image = ImageNetworkIntegration.cache.image(for: request) else {
            return callBack(nil)
        }
        
        var needBlur = false
        if let path = request.url?.absoluteString {
            let model = FileModel(path: path)
            needBlur = CensorManager.isCensored(model: model)
        }
        
        if needBlur {
            Helper.performOnUtilityThread { [weak image] in
                let blurred = image?.applyBlur(radius: BlurRadiusOriginal)
                Helper.performOnMainThread {
//                    if let blurred = blurred {
//                        let img = blurred
                        callBack(blurred)
//                    } else {
//                        callBack(nil)
//                    }
                }
            }
            
            return
        }
        
        callBack(image)
        
    }
    
    func cancelLoad(for photo: AXPhotoProtocol) {
        
    }
    
    func cancelAllLoads() {
//        let _ = self.requests.map({ self.imageDownloader.cancelRequest(with: $0) })
//        self.requests = []
    }
    
}

class ThreadImageViewer: NSObject {
//    var media: [MWPhoto] = []
//    var anchor: Int = 0
    
    private var dataSource: AXPhotosDataSource?
    private(set) lazy var browser: AXPhotosViewController? = nil
    private let anchor: FileModel
    
    init(files: [FileModel], anchor: FileModel) {
        self.anchor = anchor
        super.init()
        self.process(files: files)
        self.setupBrowser()
    }
    
    private func process(files: [FileModel]) {
        var photos: [AXPhotoProtocol] = []
        var anchor = 0
        for file in files {
            guard let url = URL(string: MakeFullPath(path: file.path)) else {
                continue
            }
            if file == self.anchor {
                anchor = photos.count
            }
            let photo = AXPhoto(url: url)
            photos.append(photo)
        }
        
        self.dataSource = AXPhotosDataSource(photos: photos, initialPhotoIndex: anchor, prefetchBehavior: .aggressive)
        
    }
    
    private func setupBrowser() {
        let transitionInfo = AXTransitionInfo(interactiveDismissalEnabled: true, startingView: nil, endingView: nil)

        self.browser = ChanAXPhotosViewController(dataSource: self.dataSource, pagingConfig: nil, transitionInfo: transitionInfo, networkIntegration: ImageNetworkIntegration())
//        self.browser = AXPhotosViewController(dataSource: self.dataSource, networkIntegration: ImageNetworkIntegration())
//        self.browser?.transitionInfo = transitionInfo
//        self.browser?.
        
//        self.browser.delegate = self
//        self.browser = ChanPhotoBrowser(photos: self.media)
//        self.browser?.enableGrid = true
//        self.browser?.setCurrentPhotoIndex(UInt(self.anchor))
    }
    
}

//extension ThreadImageViewer: MWPhotoBrowserDelegate {
//    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
//        return UInt(self.media.count)
//    }
//
//    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
//        return self.media[Int(index)]
//    }
//
////    func thum
//}
