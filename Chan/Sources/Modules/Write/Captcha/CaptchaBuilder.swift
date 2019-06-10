//
//  CaptchaBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RxSwift

struct CaptchaResult {
    var captcha: ImageboardModel.Captcha?
    var accessKey: String?
}

protocol CaptchaProtocol {
    func solve(captcha: ImageboardModel.Captcha, from vc: UIViewController) -> Observable<CaptchaResult>
}


class CaptchaBuilder {
    
    class func captcha(_ type: ImageboardModel.CaptchaType = .noCaptcha) -> CaptchaProtocol? {
        if type == .invisibleRecaptcha || type == .recaptchaV2 {
            return RecaptchaManager()
        } else if type == .custom {
            return CustomCaptchaManager()
        }
        return nil
    }
}

