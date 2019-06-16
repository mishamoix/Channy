
//
//  CensorService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 14/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class CensorService: BaseService {
    
  private let service = ChanProvider<CensorTarget>(manager: ChanProvider<CensorTarget>.chanAlamofireManager())
    
    override init() {
        
    }
    
    
    func checkCensor(path: String) -> Observable<Bool?> {
      return self.service
        .rx
        .request(.censor(path: path))
        .observeOn(Helper.rxBackgroundPriorityThread)
        .asObservable()
        .flatMap({ [weak self] response -> Observable<Bool?> in
          if let json = self?.fromJson(data: response.data) {
            if let censor = json["censor"] as? Bool {
              return Observable<Bool?>.just(censor)
            }
          }
          return Observable<Bool?>.just(nil)
        })
        .catchError({ error -> Observable<Bool?> in
          return Observable<Bool?>.just(nil)
        })
    }
}
