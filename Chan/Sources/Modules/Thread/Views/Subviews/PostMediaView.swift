//
//  PostMediaView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


enum PostMediaViewActions {
    case disableParentActions
    case enableParentActions
    case copy
    case openBrowser
}

class PostMediaView: UIView {
    
    let image = ChanImageView()
    private let playIcon = UIImageView()
    private let playCanvas = UIView()
    private let disposeBag = DisposeBag()
    private let _actions: PublishSubject<PostMediaViewActions> = PublishSubject()
    
    var actions: Observable<PostMediaViewActions> {
        return self._actions.asObservable()
    }

    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func update(with file: MediaModel) {
        
        self.isHidden = false
        self.playCanvas.isHidden = file.type == .image
        self.cancelLoad()
        self.image.loadImage(media: file)
        
        
    }
    
    
    func cancelLoad() {
        self.image.cancelLoad()
    }
    
    private func setupUI() {
        self.addSubview(self.image)
        self.addSubview(self.playCanvas)
        self.playCanvas.addSubview(self.playIcon)
        
        self.image.contentMode = .scaleAspectFill
        
        self.playIcon.image = .play
        self.playIcon.tintColor = .white
        
        self.image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.playCanvas.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.playIcon.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
        }
        
        self.playCanvas.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.playCanvas.clipsToBounds = true
        
        self.addCopyLinkMenuItems()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playCanvas.layer.cornerRadius = self.playCanvas.frame.size.width / 2.0
    }
    
    private func addCopyLinkMenuItems() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(PostMediaView.longGesture))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longGesture)

//        longGesture
//            .rx
//            .event
//            .asDriver()
//            .drive(onNext: { [weak self] recognizer in
//                print(recognizer.state.rawValue)
//            })
//            .disposed(by: self.disposeBag)
//    }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return false
        return ["copyLink", "openBrowser"].contains(action.description)
    }
    
    @objc func copyLink() {
        self._actions.on(.next(.copy))

    }
    
    @objc func openBrowser() {
        self._actions.on(.next(.openBrowser))

    }

    
    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    
    @objc func longGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
//            if let self = self {
            let menu = UIMenuController.shared
            if !menu.isMenuVisible {
//                self._actions.on(.next(.copy))
                self.becomeFirstResponder()
                menu.setTargetRect(self.bounds, in: self)
                menu.setMenuVisible(true, animated: true)
                self._actions.on(.next(.enableParentActions))
            }
//            }
        }

    }
    
}
