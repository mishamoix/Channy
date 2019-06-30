//
//  HiddenThreadManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 27/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

private let ExpireTime: Double = 60 * 60 * 24 * 7 // 1 week
private let UpdatedLessHour: Double = 60 * 60

class HiddenThreadModel: BaseModel, Decodable, Encodable {
    let id: String
    private(set) var updated: TimeInterval = Date().timeIntervalSince1970
    
    
    var needUpdate: Bool {
        let now = Date().timeIntervalSince1970
        return self.updated + UpdatedLessHour < now
    }
    
    init(id: String) {
        self.id = id
    }
    
    func update() {
        self.updated = Date().timeIntervalSince1970
    }
    

    
    
    enum CodingKeys : String, CodingKey {
        case id
        case updated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.updated, forKey: .updated)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.updated = try container.decode(TimeInterval.self, forKey: .updated)
    }

}

class HiddenThreadManager {
    static let shared = HiddenThreadManager()
    
    private var cache: [String: HiddenThreadModel] = [:]
    private let lock = NSLock()
    private var models: [HiddenThreadModel] {
        get {
            return cache.map({ return $1 })
        }
        
        set {
            var result: [String: HiddenThreadModel] = [:]
            for model in newValue {
                result[model.id] = model
            }
            self.cache = result
        }
    }
    
    private let syncObservable = Variable<Bool>(true)
    private let disposeBag = DisposeBag()
    
    init() {
        self.load()
        
        self.setupRx()
    }
    
    func add(thread: String) {
        let model = self.model(for: thread)
        model.update()
        
        self.cache[thread] = model
        
        self.sendSyncSignal()
    }
    
    func remove(thread: String) {
        self.cache.removeValue(forKey: thread)
        self.sendSyncSignal()
    }
    
    func hidden(uid: String) -> Bool {
        if let model = self.cache[uid] {
            
            if model.needUpdate {
                model.update()
                self.sendSyncSignal()
            }
            return true
        } else {
            return false
        }
    }
    
    func clear() {
        Helper.performOnBGThread {
            let now = Date().timeIntervalSince1970
            let newModels = self.models.filter({ $0.updated + ExpireTime >= now })
            self.models = newModels
            self.sync()
        }
    }
    
    private func model(for id: String) -> HiddenThreadModel {
        if let value = self.cache[id] {
            return value
        } else {
            return HiddenThreadModel(id: id)
        }
    }
    
    private func sendSyncSignal() {
        print("send sync threads")
        self.syncObservable.value = true
    }
    
    private func sync() {
        Helper.performOnBGThread {
            self.lock.lock()
            
            let models = self.models
            Values.shared.hiddenThreads = models
            
            self.lock.unlock()
            
            print("hidden thread synced")
        }
    }
    
    private func load() {
        self.models = Values.shared.hiddenThreads
//        for model in Values.shared.hiddenThreads {
//            self.cache[model.id] = model
//        }
    }
    

    
    private func setupRx() {
        self.syncObservable
            .asObservable()
            .debounce(5.0, scheduler: Helper.rxBackgroundThread)
            .subscribe(onNext: { [weak self] _ in
                self?.sync()
            })
            .disposed(by: self.disposeBag)
    }
}
