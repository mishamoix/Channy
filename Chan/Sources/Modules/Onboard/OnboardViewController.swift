//
//  OnboardViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SwiftyOnboard
import SnapKit


protocol OnboardPresentableListener: class {
    var onboards: [OnboardViewModel] { get }
    
    func openToS()
    func openPrivacy()
    func close()
}

final class OnboardViewController: BaseViewController, OnboardPresentable, OnboardViewControllable {

    private let disposeBag = DisposeBag()
    weak var listener: OnboardPresentableListener?
    private let onboard = SwiftyOnboard(frame: .zero)
    private let overlay = SwiftyOnboardOverlay()
    private let lastOnboard = LastOnboardView()
    
    private var data: [OnboardViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func acceptToS() {
        self.lastOnboard.tosSwitcher.isOn = true
        self.updateLetsGo()
    }
    func acceptPrivacy() {
        self.lastOnboard.privacySwitcher.isOn = true
        self.updateLetsGo()
    }
    
    //MARK: Private
    private func setup() {
        
        self.data = self.listener?.onboards ?? []
        
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        let overlay = self.overlay
        overlay.continueButton.isHidden = true
        overlay.skipButton.setTitle("skip".localized, for: .normal)
        overlay.skipButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.onboard.goToPage(index: self.data.count - 1, animated: true)
            })
            .disposed(by: self.disposeBag)

        
        self.setupOnboard()
        self.updateLetsGo()
        
    }
    
    private func setupRx() {
        self.lastOnboard
            .tosButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.openToS()
            })
            .disposed(by: self.disposeBag)
        
        self.lastOnboard
            .privacyButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.openPrivacy()
            })
            .disposed(by: self.disposeBag)
        
        self.lastOnboard
            .tosSwitcher
            .rx
            .value
            .subscribe(onNext: { [weak self] _ in
                self?.updateLetsGo()
            })
            .disposed(by: self.disposeBag)
        
        self.lastOnboard
            .privacySwitcher
            .rx
            .value
            .subscribe(onNext: { [weak self] _ in
                self?.updateLetsGo()
            })
            .disposed(by: self.disposeBag)
        
        self.lastOnboard
            .letsgoButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.close()
            })
            .disposed(by: self.disposeBag)

    }
    
    private func updateLetsGo() {
        if self.lastOnboard.tosSwitcher.isOn && self.lastOnboard.privacySwitcher.isOn {
            self.lastOnboard.letsgoButton.isEnabled = true
            self.lastOnboard.letsgoButton.layer.opacity = 1.0
        } else {
            self.lastOnboard.letsgoButton.isEnabled = false
            self.lastOnboard.letsgoButton.layer.opacity = 0.6
        }
    }
    
    private func setupOnboard() {
        self.onboard.frame = self.view.bounds
        self.view.addSubview(self.onboard)
        self.onboard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.onboard.style = .light
        self.onboard.backgroundColor = ThemeManager.shared.theme.background
        self.onboard.dataSource = self
        self.onboard.shouldSwipe = true
//        self.onboard.con
    }
}

extension OnboardViewController: SwiftyOnboardDataSource {
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return self.data.count
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        
        let model = self.data[index]
        
        if model.type == .standart {
            let page = SwiftyOnboardPage()
            
            page.title.font = .onboardTitle
            page.subTitle.font = .onboardSubtitle
            page.title.tintColor = ThemeManager.shared.theme.text
            page.subTitle.tintColor = ThemeManager.shared.theme.text
            
            page.title.text = model.title
            page.subTitle.text = model.subtitle
            page.imageView.image = model.image
            page.imageView.contentMode = .scaleAspectFit
            
            return page
        } else {
            return self.lastOnboard
        }
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        return self.overlay
    }

    
}
