//
//  FirebaseDB.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import FirebaseDatabase
import RxSwift

class FirebaseDB {    
    let snapshot: Variable<[String: Any]?> = Variable(nil)
    
    private let reference = Database.database().reference()
    private let disposeBag = DisposeBag()
    
    init() {
        self.run()
    }
    
    private func run() {
                
        Observable<[String: Any]>.create({ [weak self] observable -> Disposable in
            
            self?.reference.child("data").observe(DataEventType.value) { snap in
                if let sp = snap.value as? [String: Any] {
                    observable.on(.next(sp))
                }
            }
            
            return Disposables.create()
        })
        .bind(to: self.snapshot)
        .disposed(by: self.disposeBag)
        
    }
}
