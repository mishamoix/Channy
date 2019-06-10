//
//  CustomCaptcha.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RxSwift

class CustomCaptchaManager: CaptchaProtocol {
    
    func solve(captcha: ImageboardModel.Captcha, from vc: UIViewController) -> Observable<CaptchaResult> {
        let recaptchaVC = CustomCaptchaViewController()
        if let host = captcha.url {
            recaptchaVC.host = host
            let nc = BaseNavigationController(rootViewController: recaptchaVC)
            vc.present(nc, animated: true, completion: nil)
            return recaptchaVC
                .publishSubject
                .asObservable()
                .flatMap({[weak nc] result -> Observable<CaptchaResult> in
                    nc?.dismiss(animated: false, completion: nil)
                    let res = CaptchaResult(captcha: captcha, accessKey: nil)
                    return Observable<CaptchaResult>.just(res)
                })
                .catchError({ [weak nc] error -> Observable<CaptchaResult> in
                    nc?.dismiss(animated: false, completion: nil)
                    return Observable<CaptchaResult>.error(error)
                })
            
        } else {
            return Observable<CaptchaResult>.error(ChanError.none)
        }
    }
    
}
