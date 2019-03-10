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
    func send(model: WriteModel) -> Observable<WriteResponseModel>
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
            .flatMap({ [weak self] response -> Observable<String> in
                if let id = self?.fromJson(data: response.data)?["id"] as? String {
                    return Observable<String>.just(id)
                } else {
                    return Observable<String>.error(ChanError.notFound)
                }
            })
    }
    
    func send(model: WriteModel) -> Observable<WriteResponseModel> {
        return self.service
            .rx
            .request(.write(model: model))
            .asObservable()
            .flatMap({ [weak self] response -> Observable<WriteResponseModel> in
                let data = self?.fromJson(data: response.data)
                if let status = data?["Status"] as? String {
                    if status.lowercased() == "ok" {
                        var postUid: String? = nil
                        if let post = data?["Num"] as? Int {
                            postUid = String(post)
                        }
                        return Observable<WriteResponseModel>.just(.postCreated(postUid: postUid))
                    } else if let redirectUid = data?["Target"] as? Int, status.lowercased() == "redirect" {
                        return Observable<WriteResponseModel>.just(.threadCreated(threadUid: String(redirectUid)))
                    }
                }
                
                if let reason = data?["Reason"] as? String {
                    let err = ChanError.error(title: "Ошибка постинга", description: reason)
                    return Observable<WriteResponseModel>.error(err)
                } else {
                    let err = ChanError.error(title: "Ошибка постинга", description: "Неизвестная ошибка")
                    return Observable<WriteResponseModel>.error(err)

                }
            })
    }
    
    

    
}
