//
//  FirebaseManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class FirebaseManager {
    
    static let shared = FirebaseManager()
    let canLoadData: Variable<Bool> = Variable(false)
    private let db = FirebaseDB()
    private let disposeBag = DisposeBag()
    
    
    private(set) var excludeBoards: [String] = []
    private(set) var notFullAllowBoards: [String]? = nil

    private(set) var email: String? = nil
    private(set) var tg: String? = nil
    private(set) var mainInfo: String? = nil

    
    init() {
        self.run()
    }
    
    static func setup() {
        let _ = FirebaseManager.shared
    }
    
    private func run() {
        self.db
            .snapshot
            .asObservable()
            .map({ [weak self] data -> Bool in
                if let d = data {
                    self?.parse(result: d)
                }
              return data != nil
            })
            .bind(to: self.canLoadData)
            .disposed(by: self.disposeBag)
    }
    
    
    private func parse(result: [String: Any]) {
        if let exclude = result["exclude_boards"] as? [String] {
            self.excludeBoards = exclude
        }
        
        if let notFullAllow = result["not_full_allow_boards"] as? [String] {
            self.notFullAllowBoards = notFullAllow
        }
        
        if let dev_email = result["dev_email"] as? String {
            self.email = dev_email
        }
        
        if let dev_tg = result["dev_tg"] as? String {
            self.tg = dev_tg
        }
        
        if let main_info = result["main_info"] as? String {
            self.mainInfo = main_info
        }
        
        
    }
}
