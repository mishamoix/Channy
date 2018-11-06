//
//  VideoPlayer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 20/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayer: NSObject {
    
    let videoPlayer: UIViewController?
    
    init(with file: FileModel) {
        if let url = URL(string: MakeFullPath(path: file.path)) {



            let player = AVPlayerViewController()
            player.player = AVPlayer(url: url)
            player.player?.play()
            self.videoPlayer = player
        } else {
            self.videoPlayer = nil
        }

    }
}
