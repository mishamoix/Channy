//
//  ThreadImageViewer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa


    


class ThreadImageViewer: NSObject {
//    var media: [MWPhoto] = []
//    var anchor: Int = 0
    
    private var openInBrowserButton = UIButton()
    
    private var textCanvas = UIView()
    private var text = UILabel()
    private var textButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: AXPhotosDataSource?
    private(set) lazy var browser: AXPhotosViewController? = nil
    private let anchor: MediaModel
    
    init(files: [MediaModel], anchor: MediaModel) {
        self.anchor = anchor
        super.init()
        self.process(files: files)
        self.setupBrowser()
        self.setupButton()
//        self.setupText()

        
        if let idx = self.dataSource?.initialPhotoIndex, let img = self.dataSource?.photo(at: idx) {
            self.updateOverlay(with: img)
        }

    }
    
    private func process(files: [MediaModel]) {
        var photos: [AXPhotoProtocol] = []
        var anchor = 0
        for file in files {
            guard let url = file.url else {
                continue
            }
            if file == self.anchor {
                anchor = photos.count
            }
            let photo = AXChanImage(url: url)
            photos.append(photo)
        }

        self.dataSource = AXPhotosDataSource(photos: photos, initialPhotoIndex: anchor, prefetchBehavior: .aggressive)
        
    }
    
    private func setupButton() {
        let mainColor = ThemeManager.shared.theme.accnt
        self.openInBrowserButton.backgroundColor = .clear
        self.openInBrowserButton.layer.cornerRadius = DefaultCornerRadius
        self.openInBrowserButton.layer.borderWidth = 2.0
        self.openInBrowserButton.layer.borderColor = mainColor.cgColor
        self.openInBrowserButton.setTitleColor(mainColor, for: .normal)
        self.openInBrowserButton.setTitle("open_in_browser".localized, for: .normal)
        self.openInBrowserButton.titleLabel?.font = UIFont.textStrong
//
        if let overlay = self.browser?.overlayView {
            overlay.addSubview(self.openInBrowserButton)

            self.openInBrowserButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(DefaultMargin)
                make.right.equalToSuperview().offset(-DefaultMargin)
                make.height.equalTo(44)

                var bottom: CGFloat = 0

                if #available(iOS 11.0, *) {
                    bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                }

                make.bottom.equalToSuperview().offset(-DefaultMargin - bottom)
            }
        }

        self.openInBrowserButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                if let idx = self?.browser?.currentPhotoIndex, let model = self?.browser?.dataSource.photo(at: idx), let url = model.url {
                    Helper.open(url: url)
                }
            })
            .disposed(by: self.disposeBag)

        self.openInBrowserButton.isUserInteractionEnabled = true
        self.openInBrowserButton.alpha = 0
        
        
        
    }
    
    private func setupBrowser() {
        let transitionInfo = AXTransitionInfo(interactiveDismissalEnabled: true, startingView: nil, endingView: nil)
        let browser = ChanAXPhotosViewController(dataSource: self.dataSource, pagingConfig: nil, transitionInfo: transitionInfo, networkIntegration: ChanFullImageLoader())
        self.browser = browser
        browser.delegate = self
        
    }
    
    private func setupText() {
        self.textCanvas.clipsToBounds = true
        self.textCanvas.layer.cornerRadius = DefaultCornerRadius
        self.textCanvas.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5996919014)
        self.text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8499944982)
        self.text.textAlignment = .center
        self.text.text = "nsfw_content_message".localized
        self.text.numberOfLines = 0


        self.textCanvas.addSubview(self.text)
        self.textCanvas.addSubview(self.textButton)
        if let overlay = self.browser?.overlayView {
            overlay.addSubview(self.textCanvas)

            self.textCanvas.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview().offset(36)
                make.right.greaterThanOrEqualToSuperview().offset(-36)
            }

            self.text.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
            }

            self.textButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }


        self.textCanvas.alpha = 0
    }
    
    
    private func updateOverlay(with photo: AXPhotoProtocol) {
        if photo.needBlur {
            self.openInBrowserButton.setTitle("open_in_browser".localized, for: .normal)
            self.openInBrowserButton.alpha = 1
        } else {
            self.openInBrowserButton.alpha = 0
            self.textCanvas.isHidden = !photo.needBlur
        }
    }
    
}

extension ThreadImageViewer: AXPhotosViewControllerDelegate {
    func photosViewController(_ photosViewController: AXPhotosViewController, overlayView: AXOverlayView, visibilityWillChange visible: Bool) {
    }

    func photosViewController(_ photosViewController: AXPhotosViewController, didNavigateTo photo: AXPhotoProtocol, at index: Int) {
        self.updateOverlay(with: photo)
    }

    func photosViewController(_ photosViewController: AXPhotosViewController, willUpdate overlayView: AXOverlayView, for photo: AXPhotoProtocol, at index: Int, totalNumberOfPhotos: Int) {
        self.updateOverlay(with: photo)


        print(index)

    }
}

extension ThreadImageViewer: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    

}
