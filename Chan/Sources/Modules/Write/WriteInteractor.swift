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
    var vc: UIViewController { get }
    var images: [UIImage] { get }
}

protocol WriteListener: class {
    func messageWrote()
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
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .send(let text):
                    if let txt = text, txt.count > 0 {
                        self?.send(text: txt)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    
    private func send(text: String) {
        
        self.presenter.showCentralActivity()
        
        self.service
            .loadInvisibleRecaptcha()
            .observeOn(Helper.rxMainThread)
            .flatMap { [weak self] recaptchaId -> Observable<WriteModel> in
                guard let self = self else { return Observable<WriteModel>.error(ChanError.none) }
//                self.presenter.stopAnyLoaders()
                return self.presenter
                    .solveRecaptcha(with: recaptchaId)
                    .asObservable().flatMap({ [weak self] (key, resultCaptcha) -> Observable<WriteModel> in
                        if let thread = self?.service.thread, let boardUid = thread.board?.uid {
                            self?.presenter.showCentralActivity()
                            let writeModel = WriteModel(recaptchaId: key, text: text, recaptachToken: resultCaptcha, threadUid: thread.uid, boardUid: boardUid, images: self?.presenter.images ?? [])
                            return Observable<WriteModel>.just(writeModel)

                        } else {
                            return Observable<WriteModel>.error(ChanError.none)
                        }
                    })
            }
            .observeOn(Helper.rxBackgroundThread)
            .flatMap { [weak self] model -> Observable<Bool> in
                if let self = self {
//                    return Observable<Bool>.just(true)
                    return self.service.send(model: model)
                }
                return Observable<Bool>.error(ChanError.none)

            }
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] success in
                self?.presenter.stopAnyLoaders()

                if success {
                    self?.listener?.messageWrote()
                } else {
                    let error = ChanError.error(title: "Ошибка", description: "Произошла неизвестная ошибка, попробуйте еще раз")
                    ErrorDisplay(error: error).show(on: self?.presenter.vc)
                }
            }, onError: { [weak self] error in
                self?.presenter.stopAnyLoaders()
                ErrorDisplay(error: error).show(on: self?.presenter.vc)
            })
            .disposed(by: self.service.disposeBag)
    }
    
    
    private func buildWriteModel() {
        
    }
}
