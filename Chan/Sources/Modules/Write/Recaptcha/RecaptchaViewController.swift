//
//  RecaptchaViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 04/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import SnapKit

class RecaptchaViewController: BaseViewController {

    var wk: WKWebView?
    var host: String?
    var recaptchaKey: String?
    
    let publishSubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private var closeButton: UIBarButtonItem? = nil

    private let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()

        initWebView()
        
        if let wk = wk {
            wk.loadHTMLString("<body></body>", baseURL: URL(string: self.host!)!)
        }

        
    }
    
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    
    func initWebView() {
        let wkController = WKUserContentController()
        wkController.add(self, name: "reCaptchaiOS")
        wkController.addUserScript(self.readScript())
        
        let wkConfig = WKWebViewConfiguration()
        wkConfig.userContentController = wkController
        
        self.wk = WKWebView(frame: self.view.frame, configuration: wkConfig)
//        self.wk?.backgroundColor = .clear
        self.wk?.isOpaque = false
    }
    
    func readScript() -> WKUserScript {
        let scriptSource = try! String(contentsOfFile: (Bundle.main.path(forResource: "recaptchaScript", ofType: "js"))!)
        let formattedHTML = String(format: scriptSource, self.recaptchaKey!)
        return WKUserScript(source: formattedHTML, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
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
    
}


extension RecaptchaViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let args = message.body as? [String] {
            
            switch args[0] {
                
            case "didLoad":
                self.captchaDidLoad()
                break
                
            case "didSolve":
                self.captchaDidSolve(response: args[1])
                break
                
            case "didExpire":
                self.captchaDidExpire()
                break
                
            default:
                print("args[0]: \(args[0])")
                break
                
            }
        }
    }
    
    
    func captchaDidLoad() {
        if let wk = self.wk {
            wk.frame = self.view.frame
            self.view.addSubview(wk)
            wk.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            print("wk is null")
        }
    }
    
    func captchaDidSolve(response: String) {
        print("response: \(response)")
        self.publishSubject.on(.next(response))
    }
    
    func captchaDidExpire() {
        print("Captcha Expired")
        self.publishSubject.on(.error(ChanError.badRequest))
    }

}
