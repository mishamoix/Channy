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
    func format(for model: WriteModel) -> Observable<[String: Any]>
    func send(model: WriteModel) -> Observable<WriteResponseModel>
    var thread: ThreadModel { get }
    var currentImageboard: ImageboardModel { get }
}

class WriteService: BaseService, WriteServiceProtocol {
    
    private let service = ChanProvider<WriteTarget>()
    
    private(set) var thread: ThreadModel
    
    init(thread: ThreadModel) {
        self.thread = thread
    }
    
    var currentImageboard: ImageboardModel {
        return self.thread.board!.imageboard!
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
    
    
    func format(for model: WriteModel) -> Observable<[String: Any]> {
        
        return self.service
            .rx
            .request(.format(model: model))
            .asObservable()
            .flatMap({ [weak self] response -> Observable<[String: Any]> in
                let data = self?.fromJson(data: response.data)
                if let data = data {
                    return Observable<[String: Any]>.just(data)
                } else {
                    return Observable<[String: Any]>.error(ChanError.badRequest)
                }
            })
    }
    
    func send(model: WriteModel) -> Observable<WriteResponseModel> {
        
        return self.format(for: model)
            .flatMap({ [weak self] format -> Observable<Data> in
            guard let self = self else { return Observable<Data>.error(ChanError.none) }
            
            if let url = format["url"] as? String {
                model.url = url
            }
            
            return self.service
                .rx
                .request(.write(model: model, format: format))
                .asObservable()
                .map({ return $0.data })
        })
        .flatMap({ [weak self] data -> Observable<WriteResponseModel> in
            
            CookiesManager.clearCookies()
            
            let data = self?.fromJson(data: data)
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
                
                return Observable<WriteResponseModel>.just(.postCreated(postUid: nil))
                
//                let err = ChanError.error(title: "Ошибка постинга", description: "Неизвестная ошибка")
//                return Observable<WriteResponseModel>.error(err)

            }
        })
    }
    
    

    
}
