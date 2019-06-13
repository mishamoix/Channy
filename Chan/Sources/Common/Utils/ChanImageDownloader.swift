//
//  ChanImageDownloader.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift

private let MaximumActiveDownloads = 8

class ChanImageDownloader {
    private let disposeBag = DisposeBag()
    private(set) var imageLoader: ImageDownloader
    private(set) var fullImageLoader: ImageDownloader
    private let cache = AutoPurgingImageCache()

    static let shared = ChanImageDownloader()
    
    init() {
        self.imageLoader = ImageDownloader(configuration: ChanManager.imagesConfig, downloadPrioritization: ImageDownloader.DownloadPrioritization.lifo, maximumActiveDownloads: MaximumActiveDownloads, imageCache: self.cache)
        
        self.fullImageLoader = ImageDownloader(configuration: ChanManager.imagesConfig, downloadPrioritization: ImageDownloader.DownloadPrioritization.fifo, maximumActiveDownloads: MaximumActiveDownloads, imageCache: self.cache)

        
        self.setupRx()
    }
    
    func load(url: URL, competion: ImageDownloader.CompletionHandler?) -> RequestReceipt? {
        let request = URLRequest(url: url)
        return self.imageLoader.download(request, completion: competion)
    }
    
    func cancel(token: RequestReceipt?) {
        if let token = token {
            self.imageLoader.cancelRequest(with: token)
        }
    }
    
    func checkCache(url: URL) -> UIImage? {
        return self.cache.image(for: URLRequest(url: url))
    }
    
    
    private func reconfigureLoader() {
        self.imageLoader = ImageDownloader(configuration: ChanManager.imagesConfig, downloadPrioritization: ImageDownloader.DownloadPrioritization.lifo, maximumActiveDownloads: MaximumActiveDownloads, imageCache: self.cache)
        
        self.fullImageLoader = ImageDownloader(configuration: ChanManager.imagesConfig, downloadPrioritization: ImageDownloader.DownloadPrioritization.fifo, maximumActiveDownloads: MaximumActiveDownloads, imageCache: self.cache)
    }
    
    private func setupRx() {
        ProxyManager.shared
            .proxyObservable
            .asObservable()
            .subscribe({ [weak self] _ in
                self?.reconfigureLoader()
            })
            .disposed(by: self.disposeBag)
    }
    
}
