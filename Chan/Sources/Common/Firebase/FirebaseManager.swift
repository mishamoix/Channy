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
    private(set) var excludeThreads: [String] = []

    private(set) var email: String? = nil
    private(set) var tg: String? = nil
    private(set) var mainInfo: String? = nil
    private(set) var disableImages: Bool = false
    private(set) var needExcludeBoards: Bool = false
    private(set) var agreementUrl: URL? = nil
    

    
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
        
        if let devEmail = result["dev_email"] as? String {
            self.email = devEmail
        }
        
        if let devTg = result["dev_tg"] as? String {
            self.tg = devTg
        }
        
        if let mainInfo = result["main_info"] as? String {
            self.mainInfo = mainInfo
        }
        
        if let disableImages = result["disbale_images"] as? Bool {
            self.disableImages = disableImages
        }
        
        if let needExcludeBoards = result["need_exclude_boards_v0_3"] as? Bool {
            self.needExcludeBoards = needExcludeBoards
        }
        
        
        if let excludeThreads = result["exclude_threads"] as? [String] {
            self.excludeThreads = excludeThreads
        }
        
        if let agreement = result["agreement_url"] as? String, let url = URL(string: agreement) {
            self.agreementUrl = url
        }
    }
    
    func report(thread: ThreadModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        let key = formatter.string(from: Date()).replacingOccurrences(of: " ", with: "_")
        
        let value = thread.threadPath
        
        self.db.report(thread: value, key: key)
    }
}
