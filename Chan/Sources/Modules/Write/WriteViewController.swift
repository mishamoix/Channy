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
import UITextView_Placeholder


protocol WritePresentableListener: class {
    var viewActions: PublishSubject<WriteViewActions> { get }
}

final class WriteViewController: BaseViewController, WritePresentable, WriteViewControllable {
    @IBOutlet weak var textView: UITextView!
//    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var iButton: UIButton!
    @IBOutlet weak var spoilerButton: UIButton!
    @IBOutlet weak var sButton: UIButton!
    @IBOutlet weak var uButton: UIButton!
    
    private weak var sendButton: UIBarButtonItem?
    
    var vc: UIViewController { return self }
    
//    private var recaptchaView: UIView? = nil
    
    private var buttons: [UIButton] {
        return [self.bButton, self.iButton, self.spoilerButton, self.sButton, self.uButton]
    }
    
    weak var listener: WritePresentableListener?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: WritePresentable
    func solveRecaptcha(with key: String) -> Observable<(String, String)> {
        
        let manager = RecaptchaManager(recptcha: key)
        return manager
            .solve(from: self)
            .flatMap({ result -> Observable<(String, String)> in
                return Observable<(String, String)>.just((key, result))
            })

    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupTheme()
        
        let tap = UITapGestureRecognizer(target: nil, action: nil)
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        tap
            .rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
        
        self.textView.placeholder = "Введите текст"
        self.textView.placeholderColor = self.themeManager.theme.secondText.withAlphaComponent(0.4)
        self.textView.keyboardDismissMode = .onDrag
        let _ = self.buttons.map({ self.setup(button: $0) })
        
        
        let sendButton = UIBarButtonItem(title: "Отправить", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.sendButton = sendButton
        
        self.navigationItem.rightBarButtonItem = sendButton
        
    }
    
    private func setupRx() {
        self.sendButton?
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                self?.listener?.viewActions.on(.next(.send(text: self?.textView.text)))
            }).disposed(by: self.disposeBag)
        
        
        self.bButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.insert(tag: "b")
            })
            .disposed(by: self.disposeBag)
        
        self.iButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.insert(tag: "i")
            })
            .disposed(by: self.disposeBag)
        
        self.spoilerButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.insert(tag: "spoiler")
            })
            .disposed(by: self.disposeBag)
        
        self.sButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.insert(tag: "s")
            })
            .disposed(by: self.disposeBag)
        
        self.uButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.insert(tag: "u")
            })
            .disposed(by: self.disposeBag)
    }
    
    
    private func setupTheme() {
        self.themeManager.append(view: ThemeView(view: self.textView, type: .input, subtype: .none))
        let _ = self.buttons.map({ $0.tintColor = self.themeManager.theme.main })
//        self.sendButton.tintColor = self.themeManager.theme.main
    }
    

    
    
    private func setup(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = self.themeManager.theme.main.cgColor
        button.layer.cornerRadius = DefaultCornerRadius
    }
    
    
    private func insert(tag: String) {
        let open = "[\(tag)]"
        let close = "[/\(tag)]"
        
        
        let range = self.textView.selectedRange
        let start = range.location
        let end = range.location + range.length
        
        var text = self.textView.text
        
        text?.insert(contentsOf: close, at: String.Index(encodedOffset: end))
        text?.insert(contentsOf: open, at: String.Index(encodedOffset: start))
        
        self.textView.text = text
        
        if range.length == 0 {
            self.textView.selectedRange = NSMakeRange(start + open.count, 0)
        }
    }
    
    
    
}
