//
//  ProxyInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol ProxyRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProxyPresentable: Presentable {
    var listener: ProxyPresentableListener? { get set }
    
    var buildedModel: ProxyModel? { get }
    
    func updateProxy(model: ProxyModel?)
}

protocol ProxyListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProxyInteractor: PresentableInteractor<ProxyPresentable>, ProxyInteractable, ProxyPresentableListener {

    weak var router: ProxyRouting?
    weak var listener: ProxyListener?
    
    private let service: ProxyServiceProtocol
    private let disposeBag = DisposeBag()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ProxyPresentable, proxy service: ProxyServiceProtocol) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.setupRx()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    // MARK: ProxyPresentableListener
    func checkProxy() -> Observable<Bool> {
        if let model = self.presenter.buildedModel {
            if self.checkProxy(model: model) {
                return self.service.check(with: model)
            }
        }
        
        
        return Observable<Bool>.error(ChanError.error(title: "Ошибка", description: "Проверьте заполненность полей server и port"))
        
    }
    
    func saveProxy(title: String?) {
        if let model = self.presenter.buildedModel {
            if self.checkProxy(model: model) {
                Values.shared.proxy = model
                ErrorDisplay.presentAlert(with: title ?? "Успешно!", message: "Настройки прокси обновлены", dismiss: 1.0)
                return
            }
        }
        
        ErrorManager.errorHandler(for: nil, error: ChanError.error(title: "Ошибка", description: "Проверьте заполненность полей server и port")).show()
    }
    
    func deleteProxy() {
        Values.shared.proxy = nil
        ErrorDisplay.presentAlert(with: "Успешно!", message: "Настройки прокси удалены", dismiss: 1.0)

    }
    
    // MARK: Private
    private func checkProxy(model: ProxyModel) -> Bool {
        if model.server.count > 0 {
            return true
        }
        
        return false
    }
    
    
    
    private func setupRx() {

    }
}
