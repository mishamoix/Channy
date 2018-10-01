//
//  SettingsViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol SettingsPresentableListener: class {
    func limitorChanged()
}

final class SettingsViewController: UITableViewController, SettingsPresentable, SettingsViewControllable {

    @IBOutlet weak var limitorSwitch: UISwitch!
    @IBOutlet weak var writeToDevelopers: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    weak var listener: SettingsPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        
        self.limitorSwitch.isOn = Values.shared.fullAccess

        self.infoTextView.text = FirebaseManager.shared.mainInfo

        self.setupVersion()
    }
    
    private func setupRx() {
//
        self.limitorSwitch
            .rx
            .controlEvent(UIControl.Event.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if let result = self?.limitorSwitch.isOn {
                    Values.shared.fullAccess = result
                    self?.listener?.limitorChanged()
                }
            }).disposed(by: self.disposeBag)

        self.writeToDevelopers
            .rx
            .tap
            .asDriver()
            .drive(onNext: { _ in
                if let email = FirebaseManager.shared.email {
                    if let url = URL(string: "mailto:\(email)") {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                } else if let tg = FirebaseManager.shared.tg {
                    let result = "tg://msg?to=\(tg)"
                    if let url = URL(string: result), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    private func setupVersion() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            let result = "\(version).\(build)"
            self.appVersionLabel.text = result
        }

    }
}
