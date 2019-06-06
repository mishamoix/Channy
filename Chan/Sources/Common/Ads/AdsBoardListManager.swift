//
//  AdsBoardListManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 06/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class AdsBoardListManager {
    
    private let threads: [ThreadViewModel]
    private let oneAdsByCountThreads = FirebaseManager.shared.oneAdsByCountThreads
    
    init(threads: [ThreadViewModel]) {
        self.threads = threads
    }
    
    func prepareAds() -> [ThreadViewModel] {
        var result: [ThreadViewModel] = []
        
        if self.oneAdsByCountThreads != 0 {
            for (idx, thread) in self.threads.enumerated() {
                if idx != 0 && idx % oneAdsByCountThreads == 0 {
                    result.append(AdsThreadViewModel())
                }
                
                result.append(thread)
            }
        } else {
            result = self.threads
        }
        
        return result
    }
}
