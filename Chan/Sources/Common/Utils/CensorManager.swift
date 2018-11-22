
//
//  CensorManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 14/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

private let MaxParallelExecuter = 2

class CensorManagerTask {
    let publish: PublishSubject<Bool>
    let path: String
    var priority: TimeInterval
    
    var observable: Observable<Bool> {
        return self.publish.asObservable()
    }
    
    init(publish: PublishSubject<Bool>, path: String) {
        self.publish = publish
        self.path = path
        
        self.priority = Date().timeIntervalSince1970
//        self.priority = priority
    }
    
    func updatePriority() {
        self.priority = Date().timeIntervalSince1970
    }

}

class CensorManager {
    static let shared = CensorManager()
    
    private let service = CensorService()
    private var cache: [String: Bool] = [:]
    private var queue: [CensorManagerTask] = []
    private let disposeBag = DisposeBag()
    private var currentExecutersCount: Int = 0
    
    private let semaphoreRemoveQueue = DispatchSemaphore(value: 1)
    private let semaphoreAddCache = DispatchSemaphore(value: 1)

    private var maxPriority: Int {
        if self._currentMaxPriority > Int.max - 10 {
            self._currentMaxPriority = 0
        }
        
        return self._currentMaxPriority
    }
    
    private var _currentMaxPriority: Int = 0
    
    init() {}
    
    
    func censor(url: String) -> Observable<Bool> {
        
//        return Observable<Bool>.just(false)
        
        if let val = self.cachedResult(for: url) {
            return Observable<Bool>.just(val)
        } else {
            return self.createOrUpdateTask(by: url).observable
        }
    }
    
    
    static func censor(files: [FileModel]) {
        if Values.shared.censorEnabled {
            for file in files {
                let path = CensorManager.path(for: file)
                let _ = CensorManager.shared.censor(url: path)
            }
        }
    }
    
    static func path(for file: FileModel) -> String {
        return file.type == .video ? MakeFullPath(path: file.thumbnail) : MakeFullPath(path: file.path)
    }
    
    private func cachedResult(for path: String) -> Bool? {
        return self.cache[path]
    }
    
    private func findTask(by path: String) -> CensorManagerTask? {
        return self.queue.first(where: { $0.path == path })
    }
    
    private func createOrUpdateTask(by path: String) -> CensorManagerTask {
//        let priority = self.queue.count
        if let task = self.findTask(by: path) {
//            task.priority = priority
            task.updatePriority()
            self.executeNextIfCan()
            return task
        } else {
            let publish = PublishSubject<Bool>()
            let newTask = CensorManagerTask(publish: publish, path: path)
            
            self.semaphoreRemoveQueue.wait()
            self.queue.append(newTask)
            self.semaphoreRemoveQueue.signal()

            self.executeNextIfCan()
            return newTask
        }
    }
    
    private func executeNextIfCan() {
        while self.currentExecutersCount <= MaxParallelExecuter {
            if let executer = self.queue.max(by: { $0.priority < $1.priority }) {
                
                self.semaphoreRemoveQueue.wait()
                if let idx = self.queue.firstIndex(where: { $0 === executer }) {
                    self.queue.remove(at: idx)
                }
                self.semaphoreRemoveQueue.signal()
                
                print("start execute time \(executer.priority)")
//                self.queue.removeElementByReference(executer)
                
                self.service
                    .checkCensor(path: executer.path)
                    .asObservable()
                    .observeOn(Helper.createRxBackgroundThread)
                    .subscribe(onNext: { [weak self] censored in
                        self?.currentExecutersCount -= 1
                        
                        if let censored = censored {
                            self?.semaphoreAddCache.wait()
                            self?.cache[executer.path] = censored
                            print("Censored: \(censored)")
                            self?.semaphoreAddCache.signal()
                        }
                        
                        
                        executer.publish.on(.next(censored ?? false))

                        self?.executeNextIfCan()
                        
                    }, onError: { [weak self] err in
                        self?.currentExecutersCount -= 1
                        executer.publish.on(.next(false))
                    })
                    .disposed(by: self.disposeBag)

                self.currentExecutersCount += 1
            } else {
                break
            }
        }
        
        print("operations count \(self.queue.count)")
    }
}

extension ChanImageView {
    func censor(path: String) {
        CensorManager
            .shared
            .censor(url: path)
            .debug()
            .observeOn(Helper.createRxBackgroundThread)
            .subscribe(onNext: { [weak self] censored in
                print("Result set \(censored)")
                self?.isCensored = censored
            })
            .disposed(by: self.disposeBag)
    }
    
//    func cancelCensor() {
//        self.dispose()
//    }
}
