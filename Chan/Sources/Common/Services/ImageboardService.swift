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

protocol ImageboardCurrentProtocol {
    func currentImageboard() -> Observable<ImageboardModel?>
    func currentBoard() -> Observable<BoardModel?>
}

protocol ImageboardListProtocol: ImageboardCurrentProtocol {
    func selectBoard(model: BoardModel) -> Observable<Void>
}

protocol ImageboardlistSelectionProtocol: ImageboardListProtocol {
    func save(boards: [BoardModel])
}

protocol ImageboardServiceProtocol: BaseServiceProtocol, ImageboardlistSelectionProtocol {
    
    typealias DataType = ImageboardModel
    typealias ResultType = [ImageboardServiceProtocol.DataType]

//    static func instance() -> ImageboardServiceProtocol

    func reload()
    func load() -> Observable<ResultType>
    func selectImageboard(model: ImageboardModel)
    
}



class ImageboardService: BaseService, ImageboardServiceProtocol {
    private let provider = ChanProvider<ImageboardTarget>()
    private let replaySubject = ReplaySubject<ResultType>.create(bufferSize: 1) // only last value
    private let currentCachedImageboard = Variable<DataType?>(nil)
    private let currentCachedBoard = Variable<BoardModel?>(nil)
    private static let shared = ImageboardService()
    
//    private var currentCachedImageboard: DataType? = nil
    private var cachedModels: ResultType = []
    
    static func instance() -> ImageboardServiceProtocol {
        return ImageboardService.shared
    }
    
    func save(boards: [BoardModel]) {
        self.coreData.saveModels(with: boards, with: CoreDataBoard.self) {
            self.updateCurrentCachedImageboard(force: true)
        }
    }
    
    func reload() {
        
        self.loadFromCache()
        
        self.provider
            .rx
            .request(.list)
            .observeOn(Helper.rxBackgroundThread)
            .retry(RetryCount)
            .asObservable()
//            .subscribeOn(Helper.rxBackgroundThread)
            .subscribe(onNext: { [weak self] response in
                let data = self?.makeModel(data: response.data) ?? []

                for (idx, obj) in data.enumerated() {
                    obj.sort = idx
                }

                self?.coreData.saveModels(with: data, with: CoreDataImageboard.self) {
                    self?.loadFromCache()
                }
                                
            }, onError: { error in
//                self?.replaySubject.on(.error(error))
            })
            .disposed(by: self.disposeBag)

        
    }
    
    func load() -> Observable<ResultType> {
        return self.replaySubject.asObservable()
    }
    
    func selectImageboard(model new: ImageboardModel) {
        let models = self.coreData.findModels(with: CoreDataImageboard.self) as? [ImageboardModel] ?? []
        for model in models {
            model.current = new.id == model.id
        }
    
        self.coreData.saveModels(with: models, with: CoreDataImageboard.self) { [weak self] in
            self?.loadFromCache()
            self?.updateCurrentCachedImageboard(force: true)
            self?.updateCurrentCachedBoard(force: true)
        }
    }
    
    func selectBoard(model: BoardModel) -> Observable<Void> {
        
        return Observable<Void>.create({ [weak self] observer -> Disposable in
            
            guard let boards = self?.currentCachedImageboard.value?.boards else {
                observer.on(.next(Void()))
                observer.on(.completed)
                return Disposables.create()
            }
            
            let resultBoards = boards.map({ board -> BoardModel in
                board.current = board.id == model.id
                return board
            })
            
            self?.coreData.saveModels(with: resultBoards, with: CoreDataBoard.self) {
                observer.on(.next(Void()))
                observer.on(.completed)
                
                self?.updateCurrentCachedImageboard(force: true)
                self?.updateCurrentCachedBoard(force: true)
            }
            
            
            
            return Disposables.create()
        })
        
    }
    
    func currentBoard() -> Observable<BoardModel?> {
        self.updateCurrentCachedBoard()
        return self.currentCachedBoard.asObservable()
    }
    
    func currentImageboard() -> Observable<DataType?> {
        self.updateCurrentCachedImageboard()
        return self.currentCachedImageboard.asObservable()
    }
    
    
    // MARK: Private
    
    private func loadFromCache() {
        let models = self.coreData.findModels(with: CoreDataImageboard.self) as? [ImageboardModel] ?? []
        self.cachedModels = models
        self.replaySubject.on(.next(models))

    }
    
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
    
    private func updateCurrentCachedImageboard(force: Bool = false) {
        if self.currentCachedImageboard.value == nil || force {
            let result = self.coreData.findModel(with: CoreDataImageboard.self, predicate: NSPredicate(format: "current = YES")) as? ImageboardModel
            
            self.currentCachedImageboard.value = result
        }
    }
    
    private func updateCurrentCachedBoard(force: Bool = false) {
        if (self.currentCachedBoard.value == nil || force) {
            let result = self.coreData.findModel(with: CoreDataBoard.self, predicate: NSPredicate(format: "current = YES AND imageboard.current = YES")) as? BoardModel
            self.currentCachedBoard.value = result
        }
    }
    
    private func deleteOldImagesboards(new: [ImageboardModel]) {
        
    }
}
