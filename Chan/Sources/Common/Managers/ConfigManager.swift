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
                ErrorDisplay(error: ChanError.error(title: "error".localized, description: "unknown_error_restart_app".localized), buttons: []).show()
            })
            .disposed(by: self.disposeBag)
    }
    
    func start() {
        self.load()
    }
    
    private func update(config: ConfigModel) {
        self.config = config
        Enviroment.default.update(with: config)
        self.canLoadVariable.value = true
    }
}
