//
//  ThreadConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

let PostTitleTopMargin: CGFloat = PostTitleLeftMargin / 2
let PostTitleTextMargin: CGFloat = PostTitleTopMargin

let PostTitleLeftMargin: CGFloat = DefaultMargin
let PostTitleRightMargin: CGFloat = PostTitleLeftMargin

let PostTextBottomMargin: CGFloat = DefaultMargin
let PostTextLeftMargin: CGFloat = PostTitleLeftMargin
let PostTextRightMargin: CGFloat = PostTitleRightMargin

let PostCellTopMargin: CGFloat = PostTitleLeftMargin
let PostCellBottomMargin: CGFloat = PostCellTopMargin
let PostCellLeftMargin: CGFloat = DefaultMargin
let PostCellRightMargin: CGFloat = PostCellLeftMargin

let PostButtonRightMargin: CGFloat = DefaultMargin
let PostButtonBottomMargin: CGFloat = DefaultMargin
let PostButtonSize: CGSize = CGSize(width: 28, height: 20)

let PostBottomHeight = PostButtonBottomMargin + PostButtonSize.height


enum PostAction {
    case openReplys(postUid: String)
}

enum PostCellAction {
    case openReplys(cell: UICollectionViewCell)
}

