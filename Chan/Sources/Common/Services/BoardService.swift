//
//  BoardService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift


protocol BoardServiceProtocol: BaseServiceProtocol {
    typealias DataType = ThreadModel
    typealias ResultType = [DataType]
//
//
//    var board: BoardModel? { get }
//
//    func loadNext(realod needReload: Bool) -> Observable<ResultType>?
//    func update(board: BoardModel)
//
//    var saveBoardAsHomeIfSuccess: Bool { get set }
//
//    func reset()
    
    
    func loadThreads(board: BoardModel) -> Observable<ResultType>
    
}


class BoardService: BaseService, BoardServiceProtocol {
    
    private let provider = ChanProvider<BoardTarget>()
    
    private let favorite = FavoriteService()
    
    
    func loadThreads(board: BoardModel) -> Observable<ResultType> {
        
        self.favorite.update(board: board)
        
        guard let imageboard = board.imageboard else {
            
            return Observable<ResultType>.error(ChanError.error(title: "Error".localized, description: "unknown_error_restart_app".localized))
        }
        
        
        return self.provider
            .rx
            .request(.mainPage(board: String(board.id), imageboard: String(imageboard.id)))
            .asObservable()
            .map({ [weak self] response -> ResultType in
                
                guard let self = self else { return [] }
                
                let models = self.makeModel(data: response.data)
                self.updateFormDB(models: models)
                return models
            })
    }

    private func makeModel(data: Data) -> ResultType {

        if let result = ThreadModel.parseArray(from: data) {
            return result
        }
        return []
    }
    
    private func updateFormDB(models: [ThreadModel]) {
        let favorited = self.favorite.read(offset: nil)
        
        for model in models {
            if favorited.contains(where: { $0.id == model.id }) {
                model.type = .favorited
            }
        }
    }
    
}
