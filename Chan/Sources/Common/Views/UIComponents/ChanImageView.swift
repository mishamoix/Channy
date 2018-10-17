//
//  ChanImageView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage

class ChanImageView: UIImageView {
    func load(url: URL?) {
        if !Values.shared.safeMode && !FirebaseManager.shared.disableImages {
            if let url = url {
                self.cancelLoad()
                self.af_setImage(withURL: url)
            }
        } else {
            self.image = UIImage(color: .black, size: CGSize(width: 1, height: 1))
        }
    }
    func cancelLoad() {
        self.af_cancelImageRequest()
    }
}
