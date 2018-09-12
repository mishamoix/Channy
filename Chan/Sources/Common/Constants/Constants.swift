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

typealias Response<Type> = Observable<Type>


func MakeFullPath(path: String) -> String {
    return Enviroment.default.basePath + path
}
