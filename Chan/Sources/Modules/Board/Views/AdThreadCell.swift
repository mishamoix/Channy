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
    
    private var bannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    @IBOutlet weak var adView: GADUnifiedNativeAdView!
    weak private var prevModel: AdsThreadViewModel? = nil

//    private var request: GADRequest?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addAds()
    }
    
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func update(model: AdsThreadViewModel, vc: UIViewController) {
        
//        model.adBannerLoader?.delegate = self
//        model.adBannerLoader?.load(GADRequest())
        
        self.adView.isHidden = true
        
//        model.adBannerLoader.rootViewController = vc
        
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
//        self.bannerView?.removeFromSuperview()
        
        
//        let banner = GADBannerView(adSize: kGADAdSizeLargeBanner)
//        self.bannerView = banner
        
        self.addSubview(self.bannerView)
        self.bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.bannerView.adUnitID = Enviroment.default.AdUnitID
//        self.bannerView.delegate = self
    }
}

//extension AdThreadCell: GADBannerViewDelegate {
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("a")
//    }
//
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("b")
//    }
//}

extension AdThreadCell: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        self.adView.isHidden = false
        self.adView.nativeAd = nativeAd
        (self.adView.headlineView as? UILabel)?.text = nativeAd.headline
        (self.adView.bodyView as? UILabel)?.text = nativeAd.body
        (self.adView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.adView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        if let icon = self.adView.imageView as? UIImageView {
            var imageFounded = false

            icon.clipsToBounds = true
            icon.layer.cornerRadius = ImageCornerRadius
            
            for image in nativeAd.images ?? [] {
                if let img = image.image {
                    icon.image = img
                    imageFounded = true
                    break
                }
            }
            
            if !imageFounded {
                icon.image = .placeholder
            }
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    
    
}
