//
//  ThreadImageViewer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class ThreadImageViewer: NSObject {
    var media: [MWPhoto] = []
    var anchor: Int = 0
    
    private(set) lazy var browser: ChanPhotoBrowser? = nil
    
    init(files: [FileModel], anchor: FileModel) {
        super.init()
        
        self.process(files: files)
        self.anchor = files.firstIndex(of: anchor) ?? 0
        
        self.setupBrowser()
    }
    
    private func process(files: [FileModel]) {
        for file in files {
            guard let url = URL(string: MakeFullPath(path: file.path)), let preview = URL(string: MakeFullPath(path: file.thumbnail)) else {
                continue
            }
            if file.type == .video, let video = MWPhoto(url: preview) {
                video.videoURL = url
                video.isVideo = true
                self.media.append(video)
            } else if let photo = MWPhoto(url: url) {
                self.media.append(photo)
            }
        }
    }
    
    private func setupBrowser() {
//        self.browser.delegate = self
        self.browser = ChanPhotoBrowser(photos: self.media)
        self.browser?.enableGrid = true
        self.browser?.setCurrentPhotoIndex(UInt(self.anchor))
    }
    
}

extension ThreadImageViewer: MWPhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.media.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return self.media[Int(index)]
    }
    
//    func thum
}
