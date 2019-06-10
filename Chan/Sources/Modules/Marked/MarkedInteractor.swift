//
//  MarkedInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol MarkedRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MarkedPresentable: Presentable {
    var listener: MarkedPresentableListener? { get set }
    func update(with threads: [ThreadModel])
}

protocol MarkedListener: class {

    func open(thread: ThreadModel)
}

final class MarkedInteractor: PresentableInteractor<MarkedPresentable>, MarkedInteractable, MarkedPresentableListener {

    weak var router: MarkedRouting?
    weak var listener: MarkedListener?
    
    private let service: ReadMarkServiceProtocol
    private var canLoadMore: Bool = true
    
    private var threads: [ThreadModel] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MarkedPresentable, service: ReadMarkServiceProtocol) {
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
    
    // MARK: MarkedPresentableListener
    func open(idx: Int) {
        let thread = self.threads[idx]
        
        self.listener?.open(thread: thread)
    }
    
    func viewLoaded() {
        self.load(reload: true)
    }
    
    func refresh() {
        self.load(reload: true)
    }
    
    func loadNext() {
        self.load(reload: false)
    }
    
    var hasMore: Bool {
        return self.canLoadMore
    }
    
    func delete(uid: String) {
        if let thread = self.threads.first(where: { $0.id == uid }) {
            self.service.delete(marked: thread)
            self.load(reload: true)
        }
    }
    
    func deleteAll() {
        self.service.deleteAll()
        self.load(reload: true)
    }
    
    // MARK: Private
    private func setupRx() {
    }
    
    private func load(reload: Bool) {
        
        let models = self.service.read(offset: reload ? 0 : self.threads.count)
        
        if reload {
            self.canLoadMore = true
            self.threads = models
        } else {
            self.threads += models
        }

        if models.count < BatchSize {
            self.canLoadMore = false
        }
        
        self.presenter.update(with: self.threads)
        
    }
    
    
}
