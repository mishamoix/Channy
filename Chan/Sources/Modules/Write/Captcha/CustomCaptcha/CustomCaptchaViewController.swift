//
//  CustomCaptchaViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
import SnapKit

class CustomCaptchaViewController: BaseViewController {
    
    var wk: WKWebView?
    var host: String?

    let publishSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var closeButton: UIBarButtonItem? = nil
    private var solveButton: UIBarButtonItem? = nil
    
//    private let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()

        self.setup()
        
        
    }
    
    private func setup() {
        self.setupUI()
        self.setupRx()
        
        if let host = self.host, let url = URL(string: host) {
            self.wk?.load(URLRequest(url: url))
        }
    }
    
    
    func initWebView() {
//        let wkController = WKUserContentController()
        
//        let wkConfig = WKWebViewConfiguration()
//        wkConfig.userContentController = wkController
        
        let wk = WKWebView()
        self.view.addSubview(wk)
        wk.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wk.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        self.wk = wk
//        self.wk?.isOpaque = false
    }
    
    
    // MARK: Private
    private func setupUI() {
        let closeButton = UIBarButtonItem(image: UIImage.cross, landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.closeButton = closeButton
        self.navigationItem.leftBarButtonItem = closeButton
        
        let solveButton = UIBarButtonItem(title: "Я решил капчу", style: .done, target: nil, action: nil)
        self.solveButton = solveButton
        self.navigationItem.rightBarButtonItem = solveButton
        
//        self.view.addSubview(self.activity)
        
//        self.activity.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
        
//        self.activity.startAnimating()
        
    }
    
    private func setupRx() {
        self.closeButton?
            .rx
            .tap
            .asObservable()
            .flatMap({ _ -> Observable<Void> in
                return Observable<Void>.error(ChanError.none)
            })
            .bind(to: self.publishSubject)
            .disposed(by: self.disposeBag)
        
        
        self.solveButton?
            .rx
            .tap
            .asObservable()
            .flatMap({ _ -> Observable<Void> in
                return Observable<Void>.just(Void())
            })
            .bind(to: self.publishSubject)
            .disposed(by: self.disposeBag)

    }

}

extension CustomCaptchaViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
