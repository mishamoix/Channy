//
//  WebmPlayerViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 20/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
//import OGVKit
import SnapKit
import RxCocoa
import RxSwift

class WebmPlayerViewController: UIViewController {
    
//    private let disposeBag = DisposeBag()
//
//    private let file: MediaModel
//
//    // UI
//    private let playerView = OGVPlayerView()
//    private let closeButton = UIButton()
//    private let closeButtonCanvas = UIView()
//
//    init(with file: MediaModel) {
//        self.file = file
//        super.init(nibName: nil, bundle: nil)
//
//        if let url = file.url {
//            self.playerView.sourceURL = url
//        }
//
//        self.playerView.delegate = self
//
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.updateConstraint()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.playerView.sizeToFit()
//        self.closeButtonCanvas.layer.cornerRadius = self.closeButtonCanvas.frame.width / 2.0
//
//        self.playerView.setNeedsLayout()
//        self.playerView.layoutIfNeeded()
//
////        self.playerView.frame = self.playerView.frame
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setupUI()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.playerView.play()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.playerView.pause()
//    }
//
//    private func setupUI() {
//        self.view.addSubview(self.playerView)
//        self.view.addSubview(self.closeButtonCanvas)
//        self.closeButtonCanvas.addSubview(self.closeButton)
//
//        self.view.backgroundColor = .black
//
//
//        self.closeButtonCanvas.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        self.closeButtonCanvas.clipsToBounds = true
//
//        self.closeButton.setImage(UIImage.cross, for: .normal)
//        self.closeButton.tintColor = .white
//
//
//        self.closeButton
//            .rx
//            .tap
//            .asDriver().drive(onNext: { [weak self] _ in
//                self?.dismiss(animated: true, completion: nil)
//            }).disposed(by: self.disposeBag)
//
//    }
//
//
//    private func updateConstraint() {
//        self.playerView.snp.updateConstraints { make in
//            if #available(iOS 11.0, *) {
//                make.edges.equalToSuperview().inset(UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero)
//            } else {
//                make.edges.equalToSuperview()
//            }
//        }
//
//        self.closeButtonCanvas.snp.updateConstraints { make in
//            if #available(iOS 11.0, *) {
//                make.top.equalToSuperview().offset(DefaultMargin + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0))
//                make.left.equalToSuperview().offset(DefaultMargin + (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0))
//
//            } else {
//                make.top.equalToSuperview().offset(DefaultMargin)
//                make.left.equalToSuperview().offset(DefaultMargin)
//            }
//            make.size.equalTo(PostScrollDownButtonSize)
//        }
//
//
//        self.closeButton.snp.updateConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//
//    }
    

}


//extension WebmPlayerViewController: OGVPlayerDelegate {
//    func ogvPlayerControlsWillHide(_ sender: OGVPlayerView!) {
////        self.closeButtonCanvas.layer.removeAllAnimations()
////        UIView.animate(withDuration: AnimationDuration, animations: {
////            self.closeButtonCanvas.alpha = 0
////        }) { finished in
////            if finished {
////                self.closeButtonCanvas.isHidden = true
////            }
////        }
//    }
//    
//    func ogvPlayerControlsWillShow(_ sender: OGVPlayerView!) {
////        self.closeButtonCanvas.layer.removeAllAnimations()
////        self.closeButtonCanvas.isHidden = false
////        UIView.animate(withDuration: AnimationDuration, animations: {
////            self.closeButtonCanvas.alpha = 1
////        }) { finished in
////            if finished {
////            }
////        }
//    }
//}
