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
    
    
    @IBOutlet weak var cellCanvasLimitor: UIView!
    @IBOutlet weak var cellCanvasNightMode: UIView!
    @IBOutlet weak var cellCanvasVersion: UIView!
    
    @IBOutlet weak var titleLimitor: UILabel!
    @IBOutlet weak var subtitleLimitor: UILabel!
    @IBOutlet weak var titleVersion: UILabel!
//    @IBOutlet weak var subtitleVersion: UILabel!
    
    @IBOutlet weak var changeThemeButton: UIButton!
    
    private var canvas: [UIView] {
        return [cellCanvasLimitor, cellCanvasNightMode, cellCanvasVersion]
    }
    
    private var titles: [UILabel] {
        return [titleLimitor, titleVersion]
    }
    
    private var subtitels: [UILabel] {
        return [subtitleLimitor]
    }
    
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
        
        self.limitorSwitch.isOn = Values.shared.safeMode
        self.navigationItem.title = "Настройки"

        self.infoTextView.text = FirebaseManager.shared.mainInfo

        self.setupVersion()
        
        self.updateThemeText()
        self.setupTheme()
    }
    
    private func setupRx() {
//
        self.limitorSwitch
            .rx
            .controlEvent(UIControl.Event.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if let result = self?.limitorSwitch.isOn {
                    if !result {
                        let vc = UIAlertController(title: "", message: "Подтвердите что вам более 17 лет", preferredStyle: UIAlertController.Style.alert)
                        vc.addAction(UIAlertAction(title: "Мне 17+", style: .default, handler: { [weak self] _ in
                            Values.shared.safeMode = result
                            self?.listener?.limitorChanged()
                        }))
                        vc.addAction(UIAlertAction(title: "Нет", style: .destructive, handler: { [weak self] _ in
                            self?.limitorSwitch.isOn = true
                        }))
                        
                        self?.present(vc, animated: true, completion: nil)
                    } else {
                        Values.shared.safeMode = result
                        self?.listener?.limitorChanged()
                    }
                    
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
        
        
        self.changeThemeButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                let vc = UIAlertController(title: "Выберите тему", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                if IsIpad {
                    vc.popoverPresentationController?.sourceView = self.changeThemeButton
                    vc.popoverPresentationController?.sourceRect = CGRect(x: self.changeThemeButton.frame.midX, y: self.changeThemeButton.frame.midY, width: 1, height: 1)
                }

                let currentType = self.themeManager.savedThemeType
                
                if currentType != .light {
                    vc.addAction(UIAlertAction(title: "Светлая", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .light)
                        self.updateThemeText()
                        
                    }))
                }
                
                if currentType != .dark {
                    vc.addAction(UIAlertAction(title: "Темная", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .dark)
                        self.updateThemeText()

                    }))
                }
                
                if currentType != .darkBlue {

                    vc.addAction(UIAlertAction(title: "Темно-синяя", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .darkBlue)
                        self.updateThemeText()

                    }))
                }
                
                if currentType != .macaba {
                    
                    vc.addAction(UIAlertAction(title: "Macaba", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .macaba)
                        self.updateThemeText()
                        
                    }))
                }
                
                vc.addAction(UIAlertAction(title: "Отменить", style: UIAlertAction.Style.cancel, handler: nil))
                
                self.present(vc: vc, animated: true)
//                vc.prese

            })
            .disposed(by: self.disposeBag)
        
//        self.nightMode
//            .rx
//            .controlEvent(UIControl.Event.valueChanged)
//            .asDriver()
//            .drive(onNext: { [weak self] _ in
//                if let result = self?.nightMode.isOn {
//
//                    if result {
//                        self?.themeManager.save(theme: .dark)
//                    } else {
//                        self?.themeManager.save(theme: .light)
//                    }
//
//                }
//            }).disposed(by: self.disposeBag)

        
    }
    
    private func setupVersion() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
//            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            let result = "\(version) (BETA)"
            self.appVersionLabel.text = result
        } else {
          self.appVersionLabel.text = "BETA"
        }

    }
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.tableView, type: .table, subtype: .none))
        let _ = self.canvas.map({ self.themeManager.append(view: ThemeView(view: $0, type: .cell, subtype: .none)) })
        let _ = self.titles.map({ self.themeManager.append(view: ThemeView(view: $0, type: .text, subtype: .none)) })
        let _ = self.subtitels.map({ self.themeManager.append(view: ThemeView(view: $0, type: .text, subtype: .second)) })
        
        let _ = self.subtitels.map({ $0.backgroundColor = .clear })
        let _ = self.titles.map({ $0.backgroundColor = .clear })
        
        self.themeManager.append(view: ThemeView(view: self.infoTextView, type: .input, subtype: .none))
      
        self.themeManager.append(view: ThemeView(view: self.view, type: .viewControllerBG, subtype: .none))
    }
    
    
    private func updateThemeText() {
        var text = "светлая"
        switch self.themeManager.savedThemeType {
        case .dark:
            text = "темная"
        case .darkBlue:
            text = "темно-синяя"
        case .light:
            text = "светлая"
        case .macaba:
            text = "macaba"
        }
        self.changeThemeButton.setTitle("Выберите тему: сейчас \(text)", for: UIControl.State.normal)

    }
}

