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
    typealias DataType = [ThreadModel]
    typealias ResultType = ResultBoardModel<DataType>
    
    
    var board: BoardModel? { get }
//    var publish: PublishSubject<ResultType>? { get set }
  
    func loadNext(realod needReload: Bool) -> Observable<ResultType>?
    func update(board: BoardModel)
    func fetchHomeBoard() -> Observable<BoardModel?>
}


class BoardService: BaseService, BoardServiceProtocol {
    
    var board: BoardModel?
//    var publish: PublishSubject<ResultType>? = nil

    private let provider = ChanProvider<BoardTarget>()
    
    private var page = 0
    private var maxPage = 1
    
//    private var uid: String {
//        return self.board.uid
//    }
    
    private var onLoading = false

    
//    override init() {
////        self.board = board
////        super.init()
//    }
    
    func update(board: BoardModel) {
        self.board = board
    }
    
    func loadNext(realod needReload: Bool = false) -> Observable<ResultType>? {
        
        guard let board = self.board else {
            return Observable<ResultType>.error(ChanError.noModel)
        }
        
        let uid = board.uid
        
        if needReload {
            self.page = 0
            self.onLoading = false
        }
        
        if (self.page < self.maxPage) && !self.onLoading {
            self.onLoading = true

            var target: BoardTarget
            if self.page == 0 {
                target = .mainPage(board: uid)
            } else {
                target = .page(board: uid, page: self.page)
            }
            
            return self.provider.rx
                .request(target)
                .asObservable()
                .retry(RetryCount)
                .flatMap({ [weak self] response -> Observable<ResultType> in
                    

                    self?.onLoading = false
                    if let res = self?.makeModel(data: response.data) {
                        var type: ResultBoardModelType = .first
                        if let page = self?.page, page != 0 {
                            type = .page(idx: page)
                        }

                        let result = ResultType(result: res, type: type)
                        self?.page += 1

                        return Observable<ResultType>.just(result)
                    } else {
                        let result = ResultType(result: [], type: ResultBoardModelType.page(idx: self?.page ?? 0))
                        self?.page += 1

                        return Observable<ResultType>.just(result)
                    }
                })
            }
        
        return nil
    }
    
    func fetchHomeBoard() -> Observable<BoardModel?> {
        // TODO:
        return Observable<BoardModel?>.just(nil)
    }
    
    private func makeModel(data: Data) -> DataType {
        
        var result: DataType = []
        if let json = self.fromJson(data: data) {
            
            if let pages = json["pages"] as? [Int] {
                if let max = pages.max() {
                    self.maxPage = max
                }
            }
            
            if let threads = json["threads"] {
                if let valueData = self.toJson(any: threads) {
                    if let res = ThreadModel.parseArray(from: valueData) {
                        let _ = res.map{ $0.update(board: self.board) }
                        result = res
                    }
                }
            }
        }

        return result

    }
    
    
    
    
    
}
