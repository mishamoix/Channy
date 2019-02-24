//
//  BoardConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

struct BoardConstants {
    static let NavbarRightLabelRightMargin: CGFloat = 15
    static let NavbarRightLabelBottomMargin: CGFloat = 8
    static let NavbarRightLabelLeftMargin: CGFloat = 4
    
    static let NavbarLeftLabelLeftMargin: CGFloat = 12
}

let ThreadCellMinHeight: CGFloat = 110
let ThreadCellMaxHeight: CGFloat = 400
let ThreadCellTopMargin: CGFloat = 8
let ThreadCellSideMargin: CGFloat = 16

let ThreadCellCornerRadius: CGFloat = 8
let ThreadTableLoadNext: CGFloat = 300

let ThreadImageLeftMargin: CGFloat = 17.0
let ThreadImageSize: CGFloat = 62.0
let ThreadImageTextMargin: CGFloat = 14
let ThreadTextLeftMargin: CGFloat = 16

let ThreadTopMargin: CGFloat = 18
let ThreadTextBottomMargin: CGFloat = 45

let ThreadTitleMaxHeight: CGFloat = 44
let ThreadMessageMaxHeight: CGFloat = 58
let ThreadTitleMessageMargin: CGFloat = 4

let ImageCornerRadius: CGFloat = 14


enum BoardAction {
    case loadNext
    case openThread(idx: Int)
    case reload
    case goToNewBoard
    case openHome
    case copyLinkOnBoard
    case viewWillAppear
    case openByLink
    case createNewThread
}

enum BoardCellAction {
    case tapped(cell: UICollectionViewCell)
}

