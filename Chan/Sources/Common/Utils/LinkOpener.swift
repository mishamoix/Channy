//
//  LinkOpener.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12/01/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift


enum BrowserType: String {
    case safari = "Safari"
    case googleChrome = "Google Chrome"
    case firefox = "Firefox"
    case yandexBrowser = "Яндекс.Браузер"
}

struct Browser {
    var schema: String
    var type: BrowserType
    
    var fullSchema: String {
        return schema + "://"
    }
    
    var schemaForAvailableTest: String {
        return fullSchema + "http://apple.com"
    }
    
    func build(url: URL) -> URL? {
        if self.type == .firefox {
            return URL(string: "\(self.fullSchema)open-url?url=\(url.absoluteString)")
        } else if self.type == .googleChrome {
            
            if url.absoluteString.hasPrefix("https://") {
                let path = url.absoluteString.replacingOccurrences(of: "https://", with: "")
                return URL(string: "googlechrome://\(path)")
            } else {
                let path = url.absoluteString.replacingOccurrences(of: "http://", with: "")
                return URL(string: "googlechrome://\(path)")

            }
        }
        return URL(string: self.fullSchema)?.appendingPathComponent(url.absoluteString)
    }
}

class LinkOpener {
    static let shared = LinkOpener()

    private let allBrowsers: [Browser] = [
        Browser(schema: "googlechrome", type: .googleChrome),
        Browser(schema: "firefox", type: .firefox)
//        Browser(schema: "yandexbrowser", type: .yandexBrowser)
    ]
    private let disposeBag = DisposeBag()
    
    private let defaultBrowser = Browser(schema: "", type: .safari)


//    private(set) var currentBrowser: Browser

    init() {
        
//        var browser = self.defaultBrowser
//        let currentBrowserDefault = Values.shared.currentBrowser
//        if let currentBrowserDefault = currentBrowserDefault {
//            for br in self.allBrowsers {
//                if currentBrowserDefault == br.type.rawValue {
//                    browser = br
//                    break
//                }
//            }
//        }
//
//        self.currentBrowser = browser
        
    }
  
    var availableBrowsers: [Browser] {
        var result: [Browser] = [self.defaultBrowser]
        
        for br in allBrowsers {
            if let url = URL(string: br.schemaForAvailableTest), UIApplication.shared.canOpenURL(url) {
                result.append(br)
            }
        }
        
        return result
    }
    
    
    var browserIsSelected: Bool {
        return Values.shared.currentBrowser != nil
    }
    
    var currentBrowser: Browser {
        let currentBrowserDefault = Values.shared.currentBrowser
        if let currentBrowserDefault = currentBrowserDefault {
            return self.find(browser: currentBrowserDefault)
        }
        return self.defaultBrowser
    }
    
    func open(path: String?) {
        if let path = path, let url = URL(string: path) {
            self.open(url: url)
        }
    }
    
    func open(url: URL?) {
        
        
        let block = {
            let currentBrowser = self.currentBrowser
            if let url = url {
                if let resultUrl = currentBrowser.build(url: url), currentBrowser.type != .safari {
                    if UIApplication.shared.canOpenURL(resultUrl) {
                        UIApplication.shared.openURL(resultUrl)
                        return
                    }
                }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        if !self.browserIsSelected {
            self.selectDefaultBrowser()
                .subscribe { _ in
                    block()
                }
                .disposed(by: self.disposeBag)
        } else {
            block()
        }

        
    }
    
    func selectDefaultBrowser() -> Observable<Void> {
        
        var buttons: [ErrorButton] = []
        var needExcluedSelected: Bool = true
        let availableBr = self.availableBrowsers
//        let current = self.currentBrowser
        
        
        if !self.browserIsSelected {
            needExcluedSelected = false
        }
        
        if availableBr.count == 1 {
            let browser = availableBr.first!
            self.save(browser: browser)
            
            if needExcluedSelected {
                ErrorDisplay.presentAlert(with: "select_browser".localized, message: "no_external_browsers".localized, dismiss: SmallDismissTime)
//                let err = ChanError.error(title: "Выберите браузер", description: "")
//                let display = ErrorDisplay(error: err, buttons: [])
//                display.show()
            }
            
            return Observable<Void>.just(())
        }

        
        for br in availableBr {
//            if !needExcluedSelected || br.type != current.type {
                buttons.append(ErrorButton.custom(title: br.type.rawValue, style: UIAlertAction.Style.default))
//            }
        }
        
    
        
        if needExcluedSelected {
            buttons.append(.cancel)
        }
        
        
        let err = ChanError.error(title: "select_browser".localized, description: "select_browser_message".localized)
        let display = ErrorDisplay(error: err, buttons: buttons)
        
        display.show()
        
        return display.actions
            .flatMap({ (action) -> Observable<Void> in
                
                switch action {
                case .custom(let title, _):
                    let selected = self.find(browser: title)
//                    if selected.type != .safari || needExcluedSelected {
                    self.save(browser: selected)
//                    }
                default: break
                }
                
                return Observable<Void>.just(())
            })
    }
    
    private func find(browser brName: String) -> Browser {
        var browser = self.defaultBrowser
        for br in self.allBrowsers {
            if brName == br.type.rawValue {
                browser = br
            }
        }
        return browser
    }
    
    private func save(browser: Browser) {
        Values.shared.currentBrowser = browser.type.rawValue
    }
    

  
}
