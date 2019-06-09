//
//  ImageboardListInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol ImageboardListRouting: ViewableRouting {
    func settingTapped()
}

protocol ImageboardListPresentable: Presentable {
    var listener: ImageboardListPresentableListener? { get set }
    var didLoadSignalObservable: Observable<Bool> { get }
    
//    var newDataSubject: PublishSubject<[ImageboardViewModel]> { get }
    func update(data: [ImageboardViewModel])
    

    
}

protocol ImageboardListListener: class {
    func newImageboardSelected()
}

final class ImageboardListInteractor: PresentableInteractor<ImageboardListPresentable>, ImageboardListInteractable, ImageboardListPresentableListener {

    weak var router: ImageboardListRouting?
    weak var listener: ImageboardListListener?
    
    private var service: ImageboardServiceProtocol
    private let disposeBag = DisposeBag()
    
    private var data: [ImageboardModel] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ImageboardListPresentable, service: ImageboardServiceProtocol) {
        self.service = service
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.loadData()
    }

    override func willResignActive() {
        super.willResignActive()
        
    }
    
    // MARK: ImageboardListPresentableListener
    func select(idx: Int) {
        let model = self.data[idx]
        
        self.service.selectImageboard(model: model)
        
        self.listener?.newImageboardSelected()
    }
    
    func settingTapped() {
        self.router?.settingTapped()
    }
    
    // MARK: Private
    func loadData(reload: Bool = false) {
        if (reload) {
            self.service.reload()
        }
        
        self.service
            .load()
            .flatMap({ [weak self] models -> Observable<[ImageboardModel]> in
                guard let self = self else {
                    return Observable<[ImageboardModel]>.just(models)
                }
                
                return self.presenter.didLoadSignalObservable
                    .filter({ $0 })
                    .flatMap({ _ -> Observable<[ImageboardModel]> in
                        return Observable<[ImageboardModel]>.just(models)
                    })
            })
            .map({ [weak self] models -> [ImageboardViewModel] in
                let resultModels = models
                    .sorted(by: { $0.sort < $1.sort })
                self?.data = resultModels
                
                let result = resultModels
                    .map({ ImageboardViewModel(with: $0) })
                
                return result
            })
            .observeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] data in
                self?.presenter.update(data: data)
            })
            .disposed(by: self.disposeBag)
    }
}
