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


class ImageNetworkIntegration: NSObject, AXNetworkIntegrationProtocol {
  
    private static let cache = AutoPurgingImageCache()

    private static let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .lifo,
        maximumActiveDownloads: 4,
        imageCache: ImageNetworkIntegration.cache
    )
  
  
    private let requests: [URLRequest] = []

    
    var delegate: AXNetworkIntegrationDelegate?
    
    func loadPhoto(_ photo: AXPhotoProtocol) {
        if let url = photo.url {
            let request = URLRequest(url: url)

            self.image(for: request, needBlur: photo.needBlur) { [weak self, weak photo] image in
                if let img = image {
                    if let photo = photo, let self = self {
                        photo.image = img
                        self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                    }
                    
                    return

                }
                
                ImageNetworkIntegration.imageDownloader.download([request], filter: nil, progress: { [weak self, weak photo] progress in
                    guard let self = self, let photo = photo else {
                        return
                    }
                    
                    
                    self.delegate?.networkIntegration?(self, didUpdateLoadingProgress: CGFloat(progress.fractionCompleted), for: photo)
                }, progressQueue: DispatchQueue.main) { [weak self, weak photo] response in
                    
                    if let image = ImageFixer.fixIfNeeded(image: response.data) {
                        ImageNetworkIntegration.cache.add(image, for: request)
                        
                        
                        self?.image(for: request, needBlur: photo?.needBlur ?? true, callBack: { [weak self, weak photo] image in
                            if let photo = photo, let self = self {
                                photo.image = image
                                self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                            } else {
                                print("not catched")
                            }
                        })
                        
                    } else if let self = self, let photo = photo {
                        self.delegate?.networkIntegration(self, loadDidFailWith: response.error ?? ChanError.badRequest, for: photo)
                    }
                }
            }
            

        }
    }
    
    @objc func origianl(for photo: AXPhotoProtocol) -> UIImage? {
        if let url = photo.url {
            let request = URLRequest(url: url)
            return ImageNetworkIntegration.cache.image(for: request)
        }
        
        return nil
    }
    
    func image(for request: URLRequest, needBlur: Bool, callBack: @escaping (UIImage?) -> ()){
        guard let image = ImageNetworkIntegration.cache.image(for: request) else {
            return callBack(nil)
        }
        
//        var needBlur = false
//        if let path = request.url?.absoluteString {
//            let model = FileModel(path: path)
//            needBlur = CensorManager.isCensored(model: model)
//        }
        
        if needBlur {
            Helper.performOnUtilityThread { [weak image] in
                let blurred = image?.applyBlur(percent: BlurRadiusOriginal)
                Helper.performOnMainThread {
//                    if let blurred = blurred {
//                        let img = blurred
                        callBack(blurred)
//                    } else {
//                        callBack(nil)
//                    }
                }
            }
            
            return
        }
        
        callBack(image)
        
    }
    
    func cancelLoad(for photo: AXPhotoProtocol) {
        
    }
    
    func cancelAllLoads() {
//        let _ = self.requests.map({ self.imageDownloader.cancelRequest(with: $0) })
//        self.requests = []
    }
    
}

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
    private let anchor: FileModel
    
    init(files: [FileModel], anchor: FileModel) {
        self.anchor = anchor
        super.init()
        self.process(files: files)
        self.setupBrowser()
        self.setupButton()
        self.setupText()
    }
    
    private func process(files: [FileModel]) {
        var photos: [AXPhotoProtocol] = []
        var anchor = 0
        for file in files {
            guard let url = URL(string: MakeFullPath(path: file.path)) else {
                continue
            }
            if file == self.anchor {
                anchor = photos.count
            }
            let photo = AXPhoto(url: url)
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
//        self.openInBrowserButton.setTitle("Открыть в браузере", for: .normal)
        self.openInBrowserButton.titleLabel?.font = UIFont.textStrong
        
        if let overlay = self.browser?.overlayView {
            overlay.addSubview(self.openInBrowserButton)
            
            self.openInBrowserButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(DefaultMargin)
                make.right.equalToSuperview().offset(-DefaultMargin)
                make.height.equalTo(44)
                
                var bottom: CGFloat = 0
                
                if #available(iOS 11.0, *) {
                    bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                } else {
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
                    
//                    if CensorManager.isCensored(model: FileModel(path: url.absoluteString)) {
//
//                        Helper.open(url: url)
//                    } else {
////                        model.needBlur = false
////                        model.ax_loadingState = .notLoaded
////                        if let ds = self?.browser?.dataSource {
////                            ds.initialPhotoIndex = idx
////                            self?.browser?.dataSource = ds
////                        }
//                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        self.openInBrowserButton.isUserInteractionEnabled = true
        
        
    }
    
    private func setupBrowser() {
        let transitionInfo = AXTransitionInfo(interactiveDismissalEnabled: true, startingView: nil, endingView: nil)

        let browser = ChanAXPhotosViewController(dataSource: self.dataSource, pagingConfig: nil, transitionInfo: transitionInfo, networkIntegration: ImageNetworkIntegration())
      
        self.browser = browser
        browser.delegate = self
        self.openInBrowserButton.setTitle("Открыть в браузере", for: .normal)
//        self.openInBrowserButton.alpha = CensorManager.isCensored(model: self.anchor) ? 1 : 0
//        self.textCanvas.isHidden = CensorManager.isCensored(model: self.anchor)
        
    }
    
    private func setupText() {
        self.textCanvas.clipsToBounds = true
        self.textCanvas.layer.cornerRadius = DefaultCornerRadius
        self.textCanvas.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5996919014)
        self.text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8499944982)
        self.text.textAlignment = .center
        self.text.text = "Внимание!\nКартинка может содержать нежелательный контент, некоторые люди могут посчитать это оскорбительным.\nДля просмотра картинки нажмите на текст."
        self.text.numberOfLines = 0
        
        
        self.textCanvas.addSubview(self.text)
        self.textCanvas.addSubview(self.textButton)
        if let overlay = self.browser?.overlayView {
            overlay.addSubview(self.textCanvas)
            
            self.textCanvas.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview().offset(36)
                make.right.greaterThanOrEqualToSuperview().offset(36)
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
        

    }
    
    
    private func updateOverlay(with photo: AXPhotoProtocol) {
        if let url = photo.url {
            let model = FileModel(path: url.absoluteString)
//            if CensorManager.isCensored(model: model) {
//                self.openInBrowserButton.setTitle("Открыть в браузере", for: .normal)
//                self.openInBrowserButton.alpha = 1
//                self.textCanvas.isHidden = true
//                //                self.openInBrowserButton.isEnabled = true
//            } else {
//                self.openInBrowserButton.alpha = 0
//                self.textCanvas.isHidden = !photo.needBlur
//
//                //              self.openInBrowserButton.setTitle("Показать", for: .normal)
//            }
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
    
    func addGestures(_ photosViewController: AXPhotosViewController) {
//        let tap = UITapGestureRecognizer()
//        self.textCanvas.isUserInteractionEnabled = true
//        tap.delegate = self
//        self.textCanvas.addGestureRecognizer(tap)

        self.textButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] gesture in
                if let idx = self?.browser?.currentPhotoIndex, let model = self?.browser?.dataSource.photo(at: idx), let url = model.url {
                    
//                    if !CensorManager.isCensored(model: FileModel(path: url.absoluteString)) {
//                        model.needBlur = false
//                        model.ax_loadingState = .notLoaded
//                        if let ds = self?.browser?.dataSource {
//                            ds.initialPhotoIndex = idx
//                            self?.browser?.dataSource = ds
//                        }
//                    }
                }
                
            }).disposed(by: self.disposeBag)
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
//extension ThreadImageViewer: MWPhotoBrowserDelegate {
//    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
//        return UInt(self.media.count)
//    }
//
//    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
//        return self.media[Int(index)]
//    }
//
////    func thum
//}
