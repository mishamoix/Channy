//
//  ReacptchaViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReCaptcha
import SnapKit

class InvisibleRecaptchaViewController: BaseViewController {
    
    private var closeButton: UIBarButtonItem? = nil
    private var recaptcha: ReCaptcha? = nil
    private let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    let publishSubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    var recaptchaKey: String = ""
    var host: String = ""

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
        self.configureRecaptcha(api: self.recaptchaKey)
        self.solve()
    }
    
    private func setupUI() {
        let closeButton = UIBarButtonItem(image: UIImage.cross, landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        
        self.closeButton = closeButton
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.view.addSubview(self.activity)
        
        self.activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.activity.startAnimating()
        
        self.navigationItem.title = "Recaptcha"
    }
    
    private func setupRx() {
        self.closeButton?
            .rx
            .tap
            .asObservable()
            .flatMap({ _ -> Observable<String> in
                return Observable<String>.error(ChanError.none)
            })
            .bind(to: self.publishSubject)
            .disposed(by: self.disposeBag)
    }
    
    
    private func configureRecaptcha(api key: String) {
        let recaptcha = try? ReCaptcha(apiKey: key, baseURL: URL(string: "https://boards.4chan.org"))
        recaptcha?.configureWebView({ [weak self] webView in
            webView.frame = self?.view.bounds ?? CGRect.zero
            webView.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        })
        self.recaptcha = recaptcha
    }
    
    private func solve() {
        if let recaptcha = self.recaptcha {
            recaptcha
                .rx
                .validate(on: self.view)
                .asObservable()
                .flatMap({ result -> Observable<String> in
                    return Observable<String>.just(result)
                })
                .catchError({ error -> Observable<String> in
                    return Observable<String>.error(error)
                })
                .bind(to: self.publishSubject)
                .disposed(by: self.disposeBag)
        } else {
            self.publishSubject.on(.error(ChanError.none))
        }

    }


}
