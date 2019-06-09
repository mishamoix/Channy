//
//  AdsThreadViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsThreadViewModel: ThreadViewModel {
    
    var adBannerLoader: GADAdLoader?
    var updateAd = true
    
    let adUid = UUID().uuidString
    
    override func calculateSize(max width: CGFloat) -> AdsThreadViewModel {
        self.height = AdHeightDefault
        return self
    }
    
    init() {
        super.init(with: ThreadModel(uid: ""))
        self.type = .ads
    }
    
    func updateAdBannerLoader(with vc: UIViewController) {
        if self.adBannerLoader == nil {
            self.adBannerLoader = GADAdLoader(adUnitID: Enviroment.default.AdUnitID, rootViewController: nil, adTypes: [.unifiedNative], options: nil)
        }

    }
}
