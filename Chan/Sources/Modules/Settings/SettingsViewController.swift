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
    func historyWriteChanged(write: Bool)
    func openProxy()
    func proxyEnable(changed on: Bool)
}

final class SettingsViewController: UITableViewController, SettingsPresentable, SettingsViewControllable {

    @IBOutlet weak var limitorSwitch: UISwitch!
    @IBOutlet weak var writeToDevelopers: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    @IBOutlet weak var cellCanvasLimitor: UIView!
    @IBOutlet weak var cellCanvasNightMode: UIView!
    @IBOutlet weak var cellCanvasNightMode2: UIView!

    @IBOutlet weak var cellCanvasVersion: UIView!
    
    @IBOutlet weak var titleLimitor: UILabel!
    @IBOutlet weak var subtitleLimitor: UILabel!
    @IBOutlet weak var titleVersion: UILabel!
//    @IBOutlet weak var subtitleVersion: UILabel!
    
    @IBOutlet weak var changeThemeButton: UIButton!
    @IBOutlet weak var changeDefaultBrowser: UIButton!
    
    @IBOutlet weak var cellCanvasHistory: UIView!
    @IBOutlet weak var historySwitch: UISwitch!
    @IBOutlet weak var titleHistory: UILabel!
    @IBOutlet weak var subtitleHistory: UILabel!
    
    @IBOutlet weak var proxyCanvas: UIView!
    @IBOutlet weak var proxyButton: UIButton!
    
    
    private var canvas: [UIView] {
        return [cellCanvasLimitor, cellCanvasNightMode, cellCanvasVersion, cellCanvasNightMode2, cellCanvasHistory, proxyCanvas]
    }
    
    private var titles: [UILabel] {
        return [titleLimitor, titleVersion, titleHistory]
    }
    
    private var subtitels: [UILabel] {
        return [subtitleLimitor, subtitleHistory]
    }
    
    public var managedScrollView: UIScrollView? {
        return self.tableView
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
        self.historySwitch.isOn = Values.shared.historyWrite
        self.navigationItem.title = "Settings".localized

        self.infoTextView.text = FirebaseManager.shared.mainInfo

        self.setupVersion()
        
        self.updateThemeText()
        self.updateSelectedBrowser()
        self.setupTheme()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ready".localized, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        
        self.titleLimitor.text = "safe_mode".localized
        self.subtitleLimitor.text = "safe_mode_message".localized
        self.titleHistory.text = "history_write".localized
        self.subtitleHistory.text = "history_write_message".localized
        self.titleVersion.text = "app_version".localized
        self.writeToDevelopers.setTitle("write_to_developer".localized, for: .normal)
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
                        let vc = UIAlertController(title: "", message: "age_above_17".localized, preferredStyle: UIAlertController.Style.alert)
                        vc.addAction(UIAlertAction(title: "accept_age_above_17".localized, style: .default, handler: { [weak self] _ in
                            Values.shared.safeMode = result
                            self?.listener?.limitorChanged()
                        }))
                        vc.addAction(UIAlertAction(title: "No".localized, style: .destructive, handler: { [weak self] _ in
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
                
                let vc = UIAlertController(title: "select_theme".localized, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                if IsIpad {
                    vc.popoverPresentationController?.sourceView = self.changeThemeButton
                    vc.popoverPresentationController?.sourceRect = CGRect(x: self.changeThemeButton.frame.midX, y: self.changeThemeButton.frame.midY, width: 1, height: 1)
                }

                let currentType = self.themeManager.savedThemeType
//
                if currentType != .light {
                    vc.addAction(UIAlertAction(title: "light_theme".localized, style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .light)
                        self.updateThemeText()

                    }))
                }

                if currentType != .dark {
                    vc.addAction(UIAlertAction(title: "dark_theme".localized, style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .dark)
                        self.updateThemeText()

                    }))
                }

                if currentType != .blue {

                    vc.addAction(UIAlertAction(title: "blue_theme".localized, style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .blue)
                        self.updateThemeText()

                    }))
                }

                if currentType != .superDark {

                    vc.addAction(UIAlertAction(title: "black_theme".localized, style: UIAlertAction.Style.default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.themeManager.save(theme: .superDark)
                        self.updateThemeText()

                    }))
                }
                
                vc.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: nil))
                self.present(vc: vc, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        
        self.changeDefaultBrowser
            .rx
            .tap
            .asObservable()
            .flatMap({ _ -> Observable<Void> in
                return LinkOpener.shared.selectDefaultBrowser()
            })
            .subscribe(onNext: { [weak self] _ in
                self?.updateSelectedBrowser()
            }).disposed(by: self.disposeBag)
        
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

        
        self.navigationItem
            .rightBarButtonItem?
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            })
            .disposed(by: self.disposeBag)
        
        
        self.historySwitch
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                if let value = self?.historySwitch.isOn {
                    self?.listener?.historyWriteChanged(write: value)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.proxyButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.openProxy()
            })
            .disposed(by: self.disposeBag)
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
        self.themeManager.append(view: ThemeView(view: self.view, type: .background, subtype: .none))
    }
    
    
    private func updateThemeText() {
        var text = "light_theme".localized
        switch self.themeManager.savedThemeType {
        case .dark:
            text = "dark_theme".localized
        case .blue:
            text = "blue_theme".localized
        case .light:
            text = "light_theme".localized
        case .superDark:
            text = "black_theme".localized
        }
        self.changeThemeButton.setTitle("\("select_theme_current".localized) \(text)", for: UIControl.State.normal)

    }
    
    private func updateSelectedBrowser() {
        self.changeDefaultBrowser.setTitle("\("select_browser_current".localized) \(LinkOpener.shared.currentBrowser.type.rawValue.localized)", for: UIControl.State.normal)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "main_settings".localized
        } else {
            return "additional_info".localized
        }
    }
}

