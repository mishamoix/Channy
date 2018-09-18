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
    
    
    var board: BoardModel { get }
    var publish: PublishSubject<ResultType>? { get set }
    
    func loadNext()
    func reload()
}


class BoardService: BaseService, BoardServiceProtocol {
    
    let board: BoardModel
    var publish: PublishSubject<ResultType>? = nil

    private let provider = ChanProvider<BoardTarget>()
    
    private var page = 0
    private var maxPage = 1
    
    private var uid: String {
        return self.board.uid
    }
    
    private var onLoading = false

    
    init(board: BoardModel) {
        self.board = board
        super.init()
    }
    
    func loadNext() {
        if self.page < self.maxPage && !self.onLoading {
            var target: BoardTarget
            if self.page == 0 {
                target = .mainPage(board: self.uid)
            } else {
                target = .page(board: self.uid, page: self.page)
            }
            self.onLoading = true
            self.provider.rx
                .request(target)
                .asObservable()
                .subscribe(onNext: { [weak self] response in
                    if let res = self?.makeModel(data: response.data) {
                        var type: ResultBoardModelType = .first
                        if let page = self?.page, page != 0 {
                            type = .page(idx: page)
                        }
                        
                        let result = ResultType(result: res, type: type)
                        
                        self?.publish?.on(.next(result))
                        
                        self?.page += 1
                    }
                    self?.onLoading = false
                }, onError: { [weak self] error in
                    self?.onLoading = false
                }).disposed(by: self.disposeBag)
            
        
            }
    }
    
    func reload() {
        self.page = 0
        self.loadNext()
    }
    
    private func makeModel(data: Data) -> DataType {
        
        var result: DataType = []
        if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? Dictionary<String, Any> {
            
            if let pages = json["pages"] as? [Int] {
                if let max = pages.max() {
                    self.maxPage = max
                }
            }
            
            if let threads = json["threads"] {
                if let valueData = try? JSONSerialization.data(withJSONObject: threads, options: .prettyPrinted) {
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
