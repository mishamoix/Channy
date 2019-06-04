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
    
    func solveRecaptcha(with id: String?, host: String) -> Observable<(String?, String?)>
    var vc: UIViewController { get }
    var images: [UIImage] { get }
}

protocol WriteListener: class {
    func messageWrote(model: WriteResponseModel)
}

final class WriteInteractor: PresentableInteractor<WritePresentable>, WriteInteractable, WritePresentableListener {

    weak var router: WriteRouting?
    weak var listener: WriteListener?
  
    var moduleState: WriteModuleState
    
    var viewActions: PublishSubject<WriteViewActions> = PublishSubject()
    
    private let service: WriteServiceProtocol
    private let imageboardService: ImageboardServiceProtocol
    private let disposeBag = DisposeBag()


    init(presenter: WritePresentable, service: WriteServiceProtocol, imageboardService: ImageboardServiceProtocol, state: WriteModuleState) {
        self.service = service
        self.moduleState = state
        self.imageboardService = imageboardService
        super.init(presenter: presenter)
        presenter.listener = self
        
        self.setupRx()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
      
      StatisticManager.event(name: "open_write_module", values: ["state" : self.moduleState == .create ? "create new thread": "write on thread: \(self.service.thread.uid)"])
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func imagesCount() -> Observable<Int> {
        return self.imageboardService.currentImageboard().map({ $0?.maxImages ?? 0 })
    }
    
    // MARK: Private
    private func setupRx() {
        self.viewActions
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .send(let text):
//                    if let txt = text, {
                        self?.send(text: text)
//                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    
    private func send(text txt: String? = nil) {
        
        let imgsCount = self.presenter.images.count
        let text = txt ?? ""
        
        if text.count == 0 && imgsCount == 0 {
            return
        }
        
        self.presenter.showCentralActivity()
        
        
        Observable<Void>
            .just(())
            .flatMap { [weak self] _ -> Observable<(String?, String)> in
                guard let self = self else { return Observable<(String?, String)>.error(ChanError.none) }
                return self.imageboardService.currentImageboard().map({ return ($0?.captcha?.key, $0!.baseURL!.absoluteString)})
            }
            .observeOn(Helper.rxMainThread)
            .flatMap { [weak self] (recaptchaId, host) -> Observable<WriteModel> in
                guard let self = self else { return Observable<WriteModel>.error(ChanError.none) }
                self.presenter.stopAnyLoaders()
                return self.presenter
                    .solveRecaptcha(with: recaptchaId, host: host)
                    .asObservable()
                    .flatMap({ [weak self] (key, resultCaptcha) -> Observable<WriteModel> in
                        if let thread = self?.service.thread, let boardUid = thread.board?.id, let imageboard = thread.board?.imageboard {
                            self?.presenter.showCentralActivity()
                            var treadUid = thread.id
                            if let state = self?.moduleState, state == .create {
                                treadUid = "0"
                            }
                            
                            let writeModel = WriteModel(recaptchaId: key, text: text, recaptachToken: resultCaptcha, threadUid: treadUid, boardUid: boardUid, images: self?.presenter.images ?? [], imageboard: imageboard.id)
                            
                            return Observable<WriteModel>.just(writeModel)

                        } else {
                            return Observable<WriteModel>.error(ChanError.none)
                        }
                    })
            }
            .observeOn(Helper.rxBackgroundThread)
            .flatMap { [weak self] model -> Observable<WriteResponseModel> in
                if let self = self {
//                    return Observable<Bool>.just(true)
                    return self.service.send(model: model)
                }
                return Observable<WriteResponseModel>.error(ChanError.none)

            }
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] state in
                self?.presenter.stopAnyLoaders()
                self?.listener?.messageWrote(model: state)

//                if success {
//                    self?.listener?.messageWrote()
//                } else {
//                    let error = ChanError.error(title: "Ошибка", description: "Произошла неизвестная ошибка, попробуйте еще раз")
//                    ErrorDisplay(error: error).show(on: self?.presenter.vc)
//                }
            }, onError: { [weak self] error in
                self?.presenter.stopAnyLoaders()
                ErrorDisplay(error: error).show(on: self?.presenter.vc)
            })
            .disposed(by: self.service.disposeBag)
    }
    
    
    private func buildWriteModel() {
        
    }
}
