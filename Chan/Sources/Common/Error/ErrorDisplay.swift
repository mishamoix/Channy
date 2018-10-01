//
//  ErrorDisplay.swift
//  Chan
//
//  Created by Mikhail Malyshev on 25/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

protocol ErrorDisplayProtocol {
    init(error: Error)
    init(error: Error, buttons: [ErrorButton])
    func show()
    
    var actions: PublishSubject<ErrorButton> { get }
}

enum ErrorButton {
    case ok
    case cancel
    case retry
}

class ErrorDisplay: ErrorDisplayProtocol {

    
    let actions: PublishSubject<ErrorButton> = PublishSubject()
    private let error: Error
    private var buttons: [ErrorButton] = []
    
    required init(error: Error) {
        self.error = error
        if buttons.count == 0 {
            self.buttons = [.ok]
        }
    }
    
    required convenience init(error: Error, buttons: [ErrorButton]) {
        self.init(error: error)
        self.buttons = buttons
    }
    
    func show() {
        let error = ErrorHelper(error: self.error).makeError()
        
        
        if let err = error as? ChanError {
            self.chanErrorDisplay(err)
        } else {
            let message = self.error.localizedDescription
            self.showAlertView(with: nil, message: message)
        }
    }
    
    func chanErrorDisplay(_ error: ChanError) {
        
        var title = ""
        var message = ""
        
        switch error {
        case .offline:
            title = "Сетевая ошибка"
            message = "Похоже вы оффлайн"
        case .somethingWrong(let description):
            title = "Неизвестная ошибка"
            if let descr = description {
                message = descr
            }
        default: break
        }
        
        self.showAlertView(with: title, message: message)
    }
    
    private func showAlertView(with title: String?, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        for button in self.buttons {
            switch button {
            case .ok:
                vc.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                    self.actions.on(.next(.ok))
                }))
            case .cancel:
                vc.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                    self.actions.on(.next(.cancel))
                }))
            case .retry:
                vc.addAction(UIAlertAction(title: "Попытаться снова", style: .default, handler: { _ in
                    self.actions.on(.next(.retry))
                }))
            
            }
        }
        
        Helper.performOnMainThread {
            ErrorDisplay.topViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    static func presentAlert(with title: String?, message: String, styles: [ErrorButton] = []) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        for button in styles {
            switch button {
            case .ok:
                vc.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                }))
            case .cancel:
                vc.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                }))
            case .retry:
                vc.addAction(UIAlertAction(title: "Попытаться снова", style: .default, handler: { _ in
                }))
                
            }
        }
        
        Helper.performOnMainThread {
            ErrorDisplay.topViewController?.present(vc, animated: true, completion: nil)
        }

    }
    
    private static var topViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil

    }
    
}
