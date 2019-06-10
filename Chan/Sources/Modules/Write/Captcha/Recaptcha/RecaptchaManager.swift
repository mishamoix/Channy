//
//  RecaptchaManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class RecaptchaManager: CaptchaProtocol {
    
    
    func solve(captcha: ImageboardModel.Captcha, from vc: UIViewController) -> Observable<CaptchaResult> {
        let recaptchaVC = RecaptchaViewController()
        if let key = captcha.key, let host = captcha.url {
            recaptchaVC.recaptchaKey = key
            recaptchaVC.host = host
            let nc = BaseNavigationController(rootViewController: recaptchaVC)
            vc.present(nc, animated: true, completion: nil)
            return recaptchaVC
                .publishSubject
                .asObservable()
                .flatMap({[weak nc] result -> Observable<CaptchaResult> in
                    nc?.dismiss(animated: false, completion: nil)
                    let res = CaptchaResult(captcha: captcha, accessKey: result)
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
    
//    let key: String
//    let host: String
//
//    init(recptcha key: String, host: String, type: ImageboardModel.CaptchaType = .noCaptcha ) {
//        self.key = key
//        self.host = host
//    }
//
//    func solve(from vc: UIViewController) -> Observable<String> {
//        let recaptchaVC = RecaptchaViewController()
//        recaptchaVC.recaptchaKey = self.key
//        recaptchaVC.host = self.host
//        let nc = BaseNavigationController(rootViewController: recaptchaVC)
//        vc.present(nc, animated: true, completion: nil)
//        return recaptchaVC
//            .publishSubject
//            .asObservable()
//            .flatMap({[weak nc] result -> Observable<String> in
//                nc?.dismiss(animated: false, completion: nil)
//                return Observable<String>.just(result)
//            })
//            .catchError({ [weak nc] error -> Observable<String> in
//                nc?.dismiss(animated: false, completion: nil)
//                return Observable<String>.error(error)
//            })
//    }
    
}
