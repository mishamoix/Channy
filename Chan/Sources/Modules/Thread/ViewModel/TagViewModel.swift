//
//  TagViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum TagViewModelType {
    case link(url: URL)
}

struct TagViewModel {
    let type: TagViewModelType
    let range: ClosedRange<Int>
    
    func isIdxInRange(_ idx: Int) -> Bool {
        return range.contains(idx)
    }
}
