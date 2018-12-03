//
//  WriteModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

struct WriteModel {
    let recaptchaId: String
    let text: String
    let recaptachToken: String
    let threadUid: String
    let boardUid: String
    let images: [UIImage]
}
