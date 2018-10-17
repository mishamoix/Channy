//
//  BoardConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation


let ThreadCellMinHeight: CGFloat = 107
let ThreadCellMaxHeight: CGFloat = 400
let ThreadCellTopMargin: CGFloat = 8
let ThreadCellSideMargin: CGFloat = 16

let ThreadCellCornerRadius: CGFloat = 8
let ThreadTableLoadNext: CGFloat = 300


enum BoardAction {
    case loadNext
    case openThread(idx: Int)
    case reload
}

enum BoardCellAction {
    case tapped(cell: UITableViewCell)
}
