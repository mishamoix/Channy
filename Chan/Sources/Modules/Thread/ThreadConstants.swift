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
let PostTitleLeftMargin: CGFloat = DefaultMargin
let PostTitleRightMargin: CGFloat = PostTitleLeftMargin

let PostTextTopMargin: CGFloat = PostTitleTopMargin
let PostTextBottomMargin: CGFloat = DefaultMargin
let PostTextLeftMargin: CGFloat = PostTitleLeftMargin
let PostTextRightMargin: CGFloat = PostTitleRightMargin

let PostCellTopMargin: CGFloat = PostTitleLeftMargin
let PostCellBottomMargin: CGFloat = PostCellTopMargin
let PostCellLeftMargin: CGFloat = DefaultMargin
let PostCellRightMargin: CGFloat = PostCellLeftMargin

let PostButtonRightMargin: CGFloat = DefaultMargin
let PostButtonBottomMargin: CGFloat = DefaultMargin
let PostButtonTopMargin: CGFloat = DefaultMargin
let PostButtonSize: CGSize = CGSize(width: 28, height: 20)

let PostBottomHeight = PostButtonBottomMargin + PostButtonSize.height

let PostMediaMargin = DefaultMargin
let PostMediaTopMargin = DefaultMargin


enum PostAction {
    case openReplys(postUid: String)
    case openByTextIndex(postUid: String, idx: Int)
}

enum PostCellAction {
    case openReplys(cell: UICollectionViewCell)
    case tappedAtText(idx: Int, cell: UICollectionViewCell)
    case openMedia(idx: Int, cell: UICollectionViewCell, view: UIView)
}
