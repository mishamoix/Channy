//
//  WriteViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import ReCaptcha

protocol WritePresentableListener: class {
    var viewActions: PublishSubject<WriteViewActions> { get }
}

final class WriteViewController: BaseViewController, WritePresentable, WriteViewControllable {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
  
    weak var listener: WritePresentableListener?
    
    private let disposeBag = DisposeBag()
    private var recaptcha: ReCaptcha? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: WritePresentable
    func solveRecaptcha(with key: String) -> Observable<(String, String)> {
//        return Observable<(String, String)>.create({ obs -> Disposable in
//
//
//            return Disposables.create()
//        })
        
        self.configureRecaptcha(api: key)
        if let recaptcha = self.recaptcha {
            return recaptcha
                .rx
                .validate(on: self.view)
                .asObservable()
                .flatMap({ result -> Observable<(String, String)> in
                    return Observable<(String, String)>.just((key, result))
                })
        } else {
            return Observable<(String, String)>.error(ChanError.none)
        }
        
//        return self.recaptcha?.
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupTheme()
    }
    
    private func setupRx() {
        self.sendButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.listener?.viewActions.on(.next(.send(text: self?.textView.text)))
            }).disposed(by: self.disposeBag)
    }
    
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.textView, type: .input, subtype: .none))
    }
    
    private func configureRecaptcha(api key: String) {
        self.removeRecaptcha()
        
        let recaptcha = try? ReCaptcha(apiKey: key, baseURL: URL(string: "https://2ch.hk"))
        recaptcha?.configureWebView({ [weak self] webView in
            webView.frame = self?.view.bounds ?? CGRect.zero
        })
        self.recaptcha = recaptcha
        //
        //        self.re = recaptcha
        //
        ////        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        //
        //        recaptcha?.validate(on: self.tableView, completion: { result in
        //            print(result)
        //            self.re?.reset()
        //        })
        
        //            recaptcha?
        //                .rx
        //                .validate(on: self.tableView).asObservable().subscribe(onNext: { result in
        //                    print(result)
        //                }, onError: { error in
        //                    print(error)
        //                }).disposed(by: self.disposeBag)
        //        }
    }
    
    private func removeRecaptcha() {
        self.recaptcha?.stop()
        self.recaptcha = nil
    }
    
    
    
}
