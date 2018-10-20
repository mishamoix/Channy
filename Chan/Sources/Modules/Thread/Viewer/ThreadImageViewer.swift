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
    
    private let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    private let requests: [URLRequest] = []

    
    var delegate: AXNetworkIntegrationDelegate?
    
    func loadPhoto(_ photo: AXPhotoProtocol) {
        if let url = photo.url {
            let request = URLRequest(url: url)
//            self.requests.append(request)
            self.imageDownloader.download([request], filter: nil, progress: { [weak self, photo] progress in
                guard let self = self else {
                    return
                }
                self.delegate?.networkIntegration?(self, didUpdateLoadingProgress: CGFloat(progress.fractionCompleted), for: photo)
            }, progressQueue: DispatchQueue.main) { [weak self, photo] response in
                guard let self = self else {
                    return
                }

                if let error = response.error {
                    self.delegate?.networkIntegration(self, loadDidFailWith: error, for: photo)
                } else if let data = response.data, let image = UIImage(data: data) {
                    photo.image = image
                    self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                } else {
                    self.delegate?.networkIntegration(self, loadDidFailWith: ChanError.badRequest, for: photo)
                }
            }

        }
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

        self.browser = AXPhotosViewController(dataSource: self.dataSource, pagingConfig: nil, transitionInfo: transitionInfo, networkIntegration: ImageNetworkIntegration())
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
