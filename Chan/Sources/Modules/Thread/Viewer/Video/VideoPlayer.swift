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
    
    let vlc = UIStoryboard(name: "VLCViewController", bundle: nil).instantiateViewController(withIdentifier: "VLCViewController") as! VLCViewController
    init(with file: MediaModel) {
        
        vlc.url = file.url
//
    }
    
    func play(vc: UIViewController) {
        vc.present(self.vlc, animated: true, completion: nil)
    }
}
