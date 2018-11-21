
//
//  ScrollDownButton.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ScrollDownButton: UIButton {
    
    
    private var buttonHidden = false
    private let disposeBag = DisposeBag()
    let hiddenAction: PublishSubject<Bool> = PublishSubject()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        self.setImage(UIImage.downArraw, for: .normal)
        self.tintColor = .scrollDown
      
//        for constraint in self.constraints {
//          self.removeConstraint(constraint)
//        }
      
        self.snp.makeConstraints { (make) in
            make.size.equalTo(PostScrollDownButtonSize)
        }
        
        self.layer.cornerRadius = PostScrollDownButtonSize.height / 2.0
        self.layer.borderColor = UIColor.scrollDown.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.hiddenAction
            .filter({ self.buttonHidden != $0 })
            .subscribe(onNext: { [weak self] hidden in
                if (hidden) {
                    self?.hide()
                } else {
                    self?.show()
                }
            }).disposed(by: self.disposeBag)
        
        self.setupTheme()
    }
    
    private func hide(animated: Bool = true) {
        self.layer.removeAllAnimations()
        if (!self.buttonHidden) {
            self.buttonHidden = true
            self.alpha = 1.0
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.alpha = 0.0
            }) { (completed) in
                if completed {
                    self.isHidden = true
                }
            }
        }
    }
    
    private func show(animated: Bool = true) {
        self.layer.removeAllAnimations()

        if self.buttonHidden {
            self.alpha = 0.0
            self.isHidden = false
            
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.alpha = 1.0
            }) { (completed) in
                self.buttonHidden = false
            }
        }

    }
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self, type: .action, subtype: .border))
        ThemeManager.shared.append(view: ThemeView(view: self.imageView, type: .icon, subtype: .none))
    }

}
