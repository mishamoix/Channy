//
//  VideoPlayer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 20/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AVKit
import SnapKit
//import VLCVideoView

class VideoPlayer {
    
    let vlc = VLCViewController()
    
//    let videoPlayer = VLCMediaPlayer(options: [])
//    let vc = UIViewController()
//    let a = VLCMed
    
    init(with file: MediaModel) {
        
        vlc.url = file.url
//        if let url = file.url {
////            let player = VLCMediaPlayer(options: [])
//            self.videoPlayer?.media = VLCMedia(url: url)
//        }
//
//        self.videoPlayer?.drawable = self.vc.view
////            let vc = UIViewController()
//
////            self.videoPlayer = player
////        } else {
////            self.videoPlayer = nil
////        }
//
    }
    
    func play(vc: UIViewController) {
        vc.present(self.vlc, animated: true, completion: nil)
//        self.videoPlayer?.play()
    }
}
