//
//  WebAcceptViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import WebKit


enum WebAcceptData {
    case updated(model: WebAcceptViewModel)
}

protocol WebAcceptPresentableListener: class {
    var dataSource: Variable<WebAcceptData> { get }
    func accept()
}

final class WebAcceptViewController: BaseViewController, WebAcceptPresentable, WebAcceptViewControllable {
    weak var listener: WebAcceptPresentableListener?
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
        
        self.webView.navigationDelegate = self
    }
    
    private func setupUI() {
        
    }
    
    private func setupRx() {
        self.accept
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.accept()
            }).disposed(by: self.disposeBag)
        
        self.listener?
            .dataSource
            .asObservable()
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .updated(let model): self?.update(model: model)
                }
            }).disposed(by: self.disposeBag)
        
        
    }
    
    private func update(model: WebAcceptViewModel) {
        self.mainTitle.text = model.title
        self.webView.load(URLRequest(url: model.url))
    }
}


extension WebAcceptViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
}
