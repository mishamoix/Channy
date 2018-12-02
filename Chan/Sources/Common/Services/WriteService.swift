//
//  WriteService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift


protocol WriteServiceProtocol: BaseServiceProtocol {
    func loadInvisibleRecaptcha() -> Observable<String>
    func send(model: WriteModel) -> Observable<Bool>
    var thread: ThreadModel { get }
}

class WriteService: BaseService, WriteServiceProtocol {
    
    private let service = ChanProvider<WriteTarget>()
    
    private(set) var thread: ThreadModel
    
    init(thread: ThreadModel) {
        self.thread = thread
    }

    func loadInvisibleRecaptcha() -> Observable<String> {
        return self.service
            .rx
            .request(.invisibleRecaptcha)
            .asObservable()
            .flatMap({ [weak self] response -> Observable<String>in
                if let id = self?.fromJson(data: response.data)?["id"] as? String {
                    return Observable<String>.just(id)
                } else {
                    return Observable<String>.error(ChanError.notFound)
                }
            })
    }
    
    func send(model: WriteModel) -> Observable<Bool> {
        return self.service
            .rx
            .request(.write(model: model))
            .asObservable()
            .flatMap({ [weak self] response -> Observable<Bool> in
                if let status = self?.fromJson(data: response.data)?["Status"] as? String, status.lowercased() == "ok" {
                    return Observable<Bool>.just(true)
                } else if let reason = self?.fromJson(data: response.data)?["Reason"] as? String {
                    let err = ChanError.error(title: "Ошибка постинга", description: reason)
                    return Observable<Bool>.error(err)
                }

                return Observable<Bool>.just(false)
            })
    }
    
    

    
}
