//
//  CensorCacheManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

private let MaxParallelExecuter = 2


class CensorCacheManagerTask {
    let publish: PublishSubject<UIImage>
    let path: String
    var priority: TimeInterval
    let image: UIImage
    
    var observable: Observable<UIImage> {
        return self.publish.asObservable()
    }
    
    init(publish: PublishSubject<UIImage>, path: String, image: UIImage) {
        self.publish = publish
        self.path = path
        self.image = image
        
        self.priority = Date().timeIntervalSince1970
    }
    
    func updatePriority() {
        self.priority = Date().timeIntervalSince1970
    }

}

class CensorCacheManager {
    static let shared = CensorCacheManager()
    
    private let cache = AutoPurgingImageCache()
    private var queue: [CensorCacheManagerTask] = []
    private var currentExecutersCount: Int = 0
    
    private let semaphoreRemoveQueue = DispatchSemaphore(value: 1)
    private let disposeBag = DisposeBag()

    
    func censored(image: UIImage, path: String) -> Observable<UIImage> {
        return self.createOrUpdateTask(by: path, image: image).observable
    }
    
    func cached(path: String) -> UIImage? {
        let resultPath = self.getIdentifier(path: path)
        return self.cache.image(withIdentifier: resultPath)
    }
    
    private func getIdentifier(path: String) -> String {
        return path + "blurred"
    }
    
    private func findTask(by path: String) -> CensorCacheManagerTask? {
        return self.queue.first(where: { $0.path == path })
    }
    
    private func createOrUpdateTask(by path: String, image: UIImage) -> CensorCacheManagerTask {
        if let task = self.findTask(by: path) {
            task.updatePriority()
            self.executeNextIfCan()
            return task
        } else {
            let publish = PublishSubject<UIImage>()
            let newTask = CensorCacheManagerTask(publish: publish, path: path, image: image)
//
            self.semaphoreRemoveQueue.wait()
            self.queue.append(newTask)
            self.semaphoreRemoveQueue.signal()
//
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

                self.currentExecutersCount += 1

                self.blur(image: executer.image, path: executer.path)
                    .subscribe(onNext: { [weak self] image in
                        executer.publish.on(.next(image))
                        self?.currentExecutersCount -= 1
                        self?.executeNextIfCan()
                    })
                    .disposed(by: self.disposeBag)
            } else {
                break
            }
        }
    }
    
    
    private func blur(image: UIImage, path: String) -> Observable<UIImage> {
        let resultPath = self.getIdentifier(path: path)
        return Observable<UIImage>.create { [weak self] obs -> Disposable in
                if let newImage = image.applyBlur(percent: BlurRadiusPreview) {
                    self?.cache.add(newImage, withIdentifier: resultPath)
                    obs.on(.next(newImage))
                }
                obs.on(.completed)
                
                
                return Disposables.create { }
            }
            .asObservable()
            .subscribeOn(Helper.rxBackgroundPriorityThread)
    }


}
