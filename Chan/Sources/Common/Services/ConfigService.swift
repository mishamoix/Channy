//
//  ConfigService.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/07/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class ConfigService: BaseService {
    
    private let provider = ChanProvider<ConfigTarget>()
    
    func load() -> Observable<ConfigModel> {
        return self.provider
            .rx
            .request(.config)
            .asObservable()
            .flatMap({ [weak self] response -> Observable<ConfigModel> in
                guard let self = self else { return Observable<ConfigModel>.error(ChanError.noModel) }
                if let model = self.makeModel(data: response.data) {
                    return Observable<ConfigModel>.just(model)
                } else {
                    return Observable<ConfigModel>.error(ChanError.noModel)
                }
            })
    }
    
    
    private func makeModel(data: Data) -> ConfigModel? {
        if let result = ConfigModel.parse(from: data) {
            return result
        }
        return nil
    }
    
}
