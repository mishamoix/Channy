//
//  AdsPostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsPostCell: UICollectionViewCell {
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    
    weak private var prevModel: AdPostViewModel? = nil
    //    private var request: GADRequest?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addAds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addAds()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func update(model: AdPostViewModel, vc: UIViewController) {
        
        if let prev = self.prevModel {
            if prev.adUid != model.adUid {
                self.prevModel?.updateAd = true
                self.prevModel = model
            }
        } else {
            self.prevModel = model
        }
        
        if self.bannerView.rootViewController == nil || model.updateAd {
            self.bannerView.rootViewController = vc
            self.bannerView.load(GADRequest())
            model.updateAd = false
        }
    
    }
    
    private func addAds() {
        self.addSubview(self.bannerView)
        self.bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.bannerView.adUnitID = Enviroment.default.AdUnitID
        
    }
}
