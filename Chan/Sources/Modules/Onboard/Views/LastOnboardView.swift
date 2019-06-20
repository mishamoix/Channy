//
//  LastOnboardView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class LastOnboardView: SwiftyOnboardPage {

    public var tosButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "term_of_service".localized, attributes: [NSAttributedString.Key.foregroundColor : ThemeManager.shared.theme.accnt, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    public var privacyButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "privacy_policy".localized, attributes: [NSAttributedString.Key.foregroundColor : ThemeManager.shared.theme.accnt, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        button.contentHorizontalAlignment = .left
        button.sizeToFit()
        return button
    }()
    
    public var tosSwitcher: UIButton = {
        let button = UIButton()
        button.tintColor = ThemeManager.shared.theme.accnt
//        button.intColor = ThemeManager.shared.theme.accnt
        button.setImage(.checkboxUnchecked, for: .normal)
        return button
    }()
    
    public var privacySwitcher: UIButton = {
        let button = UIButton()
        button.tintColor = ThemeManager.shared.theme.accnt
//        button.onTintColor = ThemeManager.shared.theme.accnt
        button.setImage(.checkboxUnchecked, for: .normal)
        return button
    }()

    public var letsgoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemeManager.shared.theme.accnt
        button.layer.cornerRadius = 14
        button.setTitle("lets_go".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return button
    }()
    
    override func setUp() {
        self.addSubview(imageView)
        
        self.imageView.image = .onboardingLegion
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(252)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
        }
        
        let controlOffset: CGFloat = 20

        self.addSubview(self.tosButton)
        self.addSubview(self.tosSwitcher)
        
        self.tosButton.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(controlOffset)
            make.left.equalToSuperview().offset(controlOffset)
        }
        
        self.tosSwitcher.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(controlOffset)
            make.right.equalToSuperview().offset(-controlOffset)
            make.height.width.equalTo(44)
        }
        
        self.addSubview(self.privacyButton)
        self.addSubview(self.privacySwitcher)
        
        self.privacyButton.snp.makeConstraints { make in
            make.top.equalTo(self.tosButton.snp.bottom).offset(controlOffset)
            make.left.equalToSuperview().offset(controlOffset)
            make.right.equalTo(self.privacySwitcher.snp.left).inset(-8)
        }
        
        self.privacySwitcher.snp.makeConstraints { make in
            make.top.equalTo(self.tosButton.snp.bottom).offset(controlOffset)
            make.right.equalToSuperview().offset(-controlOffset)
            make.height.width.equalTo(44)
        }

        self.addSubview(self.letsgoButton)
        self.letsgoButton.snp.makeConstraints { make in
            make.width.equalTo(270)
            make.height.equalTo(43)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.privacyButton.snp.bottom).offset(controlOffset)
        }

    }

}
