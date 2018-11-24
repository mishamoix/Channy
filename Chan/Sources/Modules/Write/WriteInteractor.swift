//
//  WriteInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol WriteRouting: ViewableRouting {
    func close()
}

protocol WritePresentable: Presentable {
    var listener: WritePresentableListener? { get set }
    
    func solveRecaptcha(with id: String) -> Observable<(String, String)>
}

protocol WriteListener: class {
    func load()
}

final class WriteInteractor: PresentableInteractor<WritePresentable>, WriteInteractable, WritePresentableListener {

    weak var router: WriteRouting?
    weak var listener: WriteListener?
    
    var viewActions: PublishSubject<WriteViewActions> = PublishSubject()
    
    private let service: WriteServiceProtocol
    private let disposeBag = DisposeBag()


    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: WritePresentable, service: WriteServiceProtocol) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
        
        self.setupRx()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: Private
    private func setupRx() {
        self.viewActions
            .subscribe(onNext: { action in
                switch action {
                case .send(let text):
                    if let txt = text, txt.count > 0 {
                        self.send(text: txt)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    
    private func send(text: String) {
        
        self.service
            .loadInvisibleRecaptcha()
            .observeOn(Helper.rxMainThread)
            .flatMap { [weak self] recaptchaId -> Observable<WriteModel> in
                guard let self = self else { return Observable<WriteModel>.error(ChanError.none) }
                
                return self.presenter
                    .solveRecaptcha(with: recaptchaId)
                    .asObservable().flatMap({ [weak self] (key, resultCaptcha) -> Observable<WriteModel> in
                        if let thread = self?.service.thread, let boardUid = thread.board?.uid {
                            
                            let writeModel = WriteModel(recaptchaId: key, text: text, recaptachToken: resultCaptcha, threadUid: thread.uid, boardUid: boardUid)
                            return Observable<WriteModel>.just(writeModel)

                        } else {
                            return Observable<WriteModel>.error(ChanError.none)
                        }
                    })
            }
            .observeOn(Helper.rxBackgroundThread)
            .flatMap { [weak self] model -> Observable<Bool> in
                if let self = self {
                    return self.service.send(model: model)
                }
                return Observable<Bool>.error(ChanError.none)

            }.subscribe(onNext: { [weak self] success in
                if success {
                    Helper.performOnMainThread {
                        self?.listener?.load()
                        self?.router?.close()
                    }
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: self.service.disposeBag)
    }
    
    
    private func buildWriteModel() {
        
    }
}
