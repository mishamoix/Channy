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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ImageboardListPresentable: Presentable {
    var listener: ImageboardListPresentableListener? { get set }
    var didLoadSignalObservable: Observable<Bool> { get }
    
    func update(data: [ImageboardViewModel])
    
}

protocol ImageboardListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ImageboardListInteractor: PresentableInteractor<ImageboardListPresentable>, ImageboardListInteractable, ImageboardListPresentableListener {

    weak var router: ImageboardListRouting?
    weak var listener: ImageboardListListener?
    
    private var service: ImageboardServiceProtocol
    private let disposeBag = DisposeBag()

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
            .map({ models -> [ImageboardViewModel] in
                let result = models
                    .sorted(by: { $0.sort < $1.sort })
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
