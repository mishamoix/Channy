//
//  ThreadConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

let ThreadCornerRadius: CGFloat = 5


let PostHeaderHeight: CGFloat = 62

let PostTitleTopMargin: CGFloat = PostTitleLeftMargin / 2
let PostTitleLeftMargin: CGFloat = DefaultMargin
let PostTitleRightMargin: CGFloat = PostTitleLeftMargin

let PostTextTopMargin: CGFloat = PostTitleTopMargin
let PostTextBottomMargin: CGFloat = DefaultMargin
let PostTextLeftMargin: CGFloat = 22
let PostTextRightMargin: CGFloat = 12

let PostCellTopMargin: CGFloat = PostTitleLeftMargin
let PostCellBottomMargin: CGFloat = PostCellTopMargin
let PostCellLeftMargin: CGFloat = DefaultMargin
let PostCellRightMargin: CGFloat = PostCellLeftMargin

let PostButtonRightMargin: CGFloat = DefaultMargin
let PostButtonBottomMargin: CGFloat = DefaultMargin
let PostButtonTopMargin: CGFloat = DefaultMargin
let PostButtonSize: CGSize = CGSize(width: 36, height: 28)

let PostBottomHeight = PostButtonBottomMargin + PostButtonSize.height

let PostMediaMargin = DefaultMargin
let PostMediaTopMargin = DefaultMargin

let PostScrollDownButtonSize = CGSize(width: 44, height: 44)
let PostScrollDownButtonRightMargin = MediumMargin
let PostScrollDownButtonBottomMargin = MediumMargin

let PostTopOffsetNumber: CGFloat = 11
let PostHeaderBottomOffset: CGFloat = 13


//let PostScrollDownButtonImageSize = CGSize(width: 44, height: 44)

enum PostAction {
    case openReplys(postUid: Int)
    case openPostReply(postUid: Int)
    case reply(postUid: Int)
    case openLink(postUid: Int, url: URL)
    case refresh
    case popToRoot
    case reportThread
    case copyPost(postUid: Int)
    case cutPost(postUid: Int)
    case copyLinkPost(postUid: Int)
    case copyMedia(media: MediaModel)
    case openMediaBrowser(media: MediaModel)

    case open(media: MediaModel)
    case copyLinkOnThread
    case replyThread
    case changeFavorite

}

enum PostCellAction {
    case openReplys(cell: UICollectionViewCell)
    case reply(cell: UICollectionViewCell)
    case tappedAtLink(url: URL, cell: UICollectionViewCell)
    case openPostReply(reply: Int, cell: UICollectionViewCell)
    case openMedia(idx: Int, cell: UICollectionViewCell, view: UIImageView)
    
    case copyText(cell: UICollectionViewCell)
    case copyOriginalText(cell: UICollectionViewCell)
    case copyMediaLink(cell: UICollectionViewCell, idx: Int)
    case openBrowserMediaLink(cell: UICollectionViewCell, idx: Int)

    case copyPostLink(cell: UICollectionViewCell)

}

