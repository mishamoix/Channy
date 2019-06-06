//
//  AdThreadCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMobileAds

class AdThreadCell: UICollectionViewCell {
    
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bannerView)
        self.bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.bannerView.adUnitID = Enviroment.default.AdUnitID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func update(vc: UIViewController) {
        if self.bannerView.rootViewController == nil {
            self.bannerView.rootViewController = vc
            self.bannerView.load(GADRequest())
        }

    }
}
