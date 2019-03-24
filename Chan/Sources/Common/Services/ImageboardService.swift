//
//  ImageboardService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

protocol ImageboardServiceProtocol: BaseServiceProtocol {
    
    typealias DataType = ImageboardModel
    typealias ResultType = [ImageboardServiceProtocol.DataType]

//    static func instance() -> ImageboardServiceProtocol

    func reload()
    func load() -> Observable<ResultType>
    
    func currentImageboard() -> DataType?
}

class ImageboardService: BaseService, ImageboardServiceProtocol {
    private let provider = ChanProvider<ImageboardTarget>()
    private let replaySubject = ReplaySubject<ResultType>.create(bufferSize: 1) // only last value
    private static let shared = ImageboardService()
    
    private var currentCachedImageboard: DataType? = nil
    
    static func instance() -> ImageboardServiceProtocol {
        return ImageboardService.shared
    }
    
    func reload() {
        
        let models = self.coreData.findModels(with: CoreDataImageboard.self) as? [ImageboardModel] ?? []
        self.replaySubject.on(.next(models))
        
        self.provider
            .rx
            .request(.list)
            .observeOn(Helper.rxBackgroundThread)
            .retry(RetryCount)
            .asObservable()
            .flatMap({ [weak self] response -> Observable<ResultType> in
                let data = self?.makeModel(data: response.data) ?? []
                
                for (idx, obj) in data.enumerated() {
                    obj.sort = idx
                    obj.current = true
                }
                
                self?.coreData.saveModels(with: data, with: CoreDataImageboard.self)
//                for imageboard in data {
//                    self?.coreData.saveModels(with: imageboard.boards, with: CoreDataBoard.self)
//                }
                
                return Observable<ResultType>.just(data)
            })
            .bind(to: self.replaySubject)
            .disposed(by: self.disposeBag)
        
            
    }
    
    func load() -> Observable<ResultType> {
        return self.replaySubject.asObservable()
    }
    
    func currentImageboard() -> DataType? {
        var result: DataType?
        if let cached = self.currentCachedImageboard {
            result = cached
        } else {
            result = self.coreData.findModel(with: CoreDataImageboard.self, predicate: NSPredicate(format: "current = YES")) as? ImageboardModel
            self.currentCachedImageboard = result
        }
        
        return result
    }
    
    // MARK: Private
    private func makeModel(data: Data) -> ResultType {
        var result: [ImageboardModel] = []
        let json = JSON(data)
        for value in json.array ?? [] {
            
            if let modelData = try? value.rawData(), let model = ImageboardModel.parse(from: modelData) {
                result.append(model)
                
                if let boardsData = try? value["boards"].rawData(), let boards = BoardModel.parseArray(from: boardsData) {
                    model.boards = boards
                }
            }
        }
        
        return result
    }
}
