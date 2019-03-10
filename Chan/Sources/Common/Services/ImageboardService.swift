//
//  ImageboardService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol ImageboardServiceProtocol: BaseServiceProtocol {
    
    typealias DataType = [ImageboardModel]
    typealias ResultType = DataType

//    static func instance() -> ImageboardServiceProtocol

    func reload()
    func load() -> Observable<ResultType>
}

class ImageboardService: BaseService, ImageboardServiceProtocol {
    private let provider = ChanProvider<ImageboardTarget>()
    private let replaySubject = ReplaySubject<ResultType>.create(bufferSize: 1) // only last value
    private static let shared = ImageboardService()
    
    static func instance() -> ImageboardServiceProtocol {
        return ImageboardService.shared
    }
    
    func reload() {
        self.provider
            .rx
            .request(.list)
            .retry(RetryCount)
            .asObservable()
            .flatMap({ [weak self] response -> Observable<ResultType> in
                let data = self?.makeModel(data: response.data) ?? []
                
                return Observable<ResultType>.just(data)
            })
            .bind(to: self.replaySubject)
            .disposed(by: self.disposeBag)
        
            
    }
    
    func load() -> Observable<ResultType> {
        return self.replaySubject.asObservable()
    }
    
    // MARK: Private
    private func makeModel(data: Data) -> DataType {
        if let res = ImageboardModel.parseArray(from: data) {
            return res
        }
        return []
    }
}
