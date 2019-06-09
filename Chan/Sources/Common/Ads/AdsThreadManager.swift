//
//  AdsThreadManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class AdsThreadManager: NSObject {
    private let posts: [PostViewModel]
    private let count = FirebaseManager.shared.oneAdsByCountInThread
    
    init(posts: [PostViewModel]) {
        self.posts = posts
    }
    
    
    func prepareAds() -> [PostViewModel] {
        var result: [PostViewModel] = []
        
        if self.count != 0 {
            for (idx, post) in self.posts.enumerated() {
                if idx != 0 && idx % self.count == 0 {
                    result.append(AdPostViewModel())
                }
                
                result.append(post)
            }
        } else {
            result = self.posts
        }
        
        return result
    }


    
}
