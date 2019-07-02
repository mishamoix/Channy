//
//  ConfigManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/07/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ConfigManager: NSObject {
    static let shared = ConfigManager()
    
    
    var config: ConfigModel?
    var canLoad: Observable<Bool> {
        return self.canLoadVariable
            .asObservable()
            .filter({ $0 })
    }
    
    private let canLoadVariable = Variable<Bool>(false)
    private let service = ConfigService()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    
    private func load() {
        self.service
            .load()
            .retry(10)
            .subscribe(onNext: { [weak self] model in
                self?.update(config: model)
            }, onError: { error in
                ErrorDisplay(error: ChanError.error(title: "Error".localized, description: "unknown_error_restart_app".localized), buttons: []).show()
            })
            .disposed(by: self.disposeBag)
    }
    
    func start() {
        self.load()
    }
    
    private func update(config: ConfigModel) {
        self.config = config
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            if config.version != version {
                let display = ErrorDisplay(error: ChanError.error(title: "version_warning".localized, description: "update_app".localized), buttons: [.custom(title: "AppStore", style: .default)])
                display
                    .actions
                    .subscribe(onNext: { [weak self, weak config] _ in
                        Helper.openInSafari(url: URL(string: "https://apps.apple.com/app/channy/id1437833949"))
                        if let config = config {
                            self?.update(config: config)
                        }
                    })
                    .disposed(by: self.disposeBag)
                
                display.show()
                return

            }
        }
        
        Enviroment.default.update(with: config)
        self.canLoadVariable.value = true
    }
}
