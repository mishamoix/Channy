//
//  WebAcceptInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol WebAcceptRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WebAcceptPresentable: Presentable {
    var listener: WebAcceptPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol WebAcceptListener: class {
    func accept()
}

final class WebAcceptInteractor: PresentableInteractor<WebAcceptPresentable>, WebAcceptInteractable, WebAcceptPresentableListener {

    weak var router: WebAcceptRouting?
    weak var listener: WebAcceptListener?
    
    let dataSource: Variable<WebAcceptData>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: WebAcceptPresentable, model: WebAcceptViewModel) {
        self.dataSource = Variable(.updated(model: model))

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
    
    func accept() {
        self.listener?.accept()
    }
}
