//
//  Constants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RxSwift

let DefaultMargin: CGFloat = 8
let MediumMargin: CGFloat = 16
let LargeMargin: CGFloat = 24

let DefaultCornerRadius: CGFloat = 8
let FastAnimationDuration: TimeInterval = 0.15

let AnimationDuration: TimeInterval = 0.25
let LongAnimationDuration: TimeInterval = 0.75

let RetryCount = 3

let BatchSize = 50


let AdHeightDefault: CGFloat = 120


let ThreadListAdCount = 15
let PostListAdCount = 20


let IsIpad = {
    return UIDevice.current.userInterfaceIdiom == .pad
}()

typealias Response<Type> = Observable<Type>


func MakeFullPath(path: String) -> String {
    if path.hasPrefix("http") {
        return path
    }
    return Enviroment.default.oldBasePath + path
}



let DefaultDismissTime: TimeInterval = 2.0
let SmallDismissTime: TimeInterval = 1.0


let BlurRadiusPreview: CGFloat = 0.06
let BlurRadiusOriginal: CGFloat = 0.02
