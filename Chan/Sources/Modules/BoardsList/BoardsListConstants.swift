//
//  BoardsListConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit


let BoardsListCellHeight: CGFloat = 40.0
let BoardsTableHeaderHeight: CGFloat = 44.0


enum BoardsListAction {
    case seacrh(text: String?)
    case openBoard(index: IndexPath)
}
