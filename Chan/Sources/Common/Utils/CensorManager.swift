
//
//  CensorManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 14/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class CensorManager {
    static let shared = CensorManager()
    
    private let service = CensorService()
    private var cache: [String: Bool] = [:]
    private let disposeBag = DisposeBag()
    
    init() {}
    
    
    func censor(url: String, cancellation: CancellationToken, callback: ((Bool) -> ())?) {
        if let val = self.cachedResult(for: url) {
            callback?(val)
//            return Observable<Bool>.just(val)
        } else {
            
//            let publish = PublishSubject<Bool>()
            
                    self.service.checkCensor(path: url)
                        .subscribe(onNext: { [weak self] result in
                            guard let self = self else {
                                if !cancellation.isCancelled {
                                    callback?(false)
                                }
                                return
                            }
                            let path = url
                            if let result = result {
                                self.cache[path] = result
                            }
                            print("Result received \(result)")
                            if !cancellation.isCancelled {
                                callback?(result ?? false)
                            }
//                            publish?.on(.next(result ?? false))
                        })
                        .disposed(by: self.disposeBag)
            
//            return publish.asObservable()
        }
    }
    
    func cachedResult(for path: String) -> Bool? {
        return self.cache[path]
    }
}

extension ChanImageView {
    func censor(path: String) {
        CensorManager
            .shared
            .censor(url: path, cancellation: self.cancellation) {
                [weak self] res in
                    print("Result set \(res)")
                    self?.isCensored = res
            }
//            .subscribe(onNext: {)
//            .disposed(by: self.disposeBag)
    }
    
    func cancelCensor() {
        self.dispose()
    }
}
