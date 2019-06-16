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


//let PostScrollDownButtonImageSize = CGSize(width: 44, height: 44)

enum PostAction {
    case openReplys(postUid: String)
    case openPostReply(postUid: String)
    case reply(postUid: String)
    case openLink(postUid: String, url: URL)
    case refresh
    case popToRoot
    case reportThread
    case copyPost(postUid: String)
    case cutPost(postUid: String)
    case copyLinkPost(postUid: String)
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
    case openPostReply(reply: String, cell: UICollectionViewCell)
    case openMedia(idx: Int, cell: UICollectionViewCell, view: UIImageView)
    
    case copyText(cell: UICollectionViewCell)
    case copyOriginalText(cell: UICollectionViewCell)
    case copyMediaLink(cell: UICollectionViewCell, idx: Int)
    case openBrowserMediaLink(cell: UICollectionViewCell, idx: Int)

    case copyPostLink(cell: UICollectionViewCell)

}

