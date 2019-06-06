//
//  SettingsInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol SettingsRouting: ViewableRouting {
    func openProxy()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingsListener: class {
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {

    weak var router: SettingsRouting?
    weak var listener: SettingsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func limitorChanged() {
//        self.listener?.limitorChanged()
    }
    
    func historyWriteChanged(write: Bool) {
        Values.shared.historyWrite = write
    }
    
    func openProxy() {
        self.router?.openProxy()
    }
    
    func proxyEnable(changed on: Bool) {
        Values.shared.proxyEnabled = on
    }
}
