//
//  WriteModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class WriteModel {
    let recaptchaId: String?
    let text: String
    let recaptachToken: String?
    let threadUid: String
    let boardUid: String
    let images: [UIImage]
    let imageboard: Int
    
    var url: String? = nil
    
    init(recaptchaId: String?, text: String, recaptachToken: String?, threadUid: String, boardUid: String, images: [UIImage], imageboard: Int) {
        self.recaptchaId = recaptchaId
        self.text = text
        self.recaptachToken = recaptachToken
        self.threadUid = threadUid
        self.boardUid = boardUid
        self.images = images
        self.imageboard = imageboard
    }
    
    var format: [String: Any] {
        var result: [String: Any] = [
            "board": self.boardUid,
            "thread": self.threadUid,
            "text": self.text,
            "images": self.images.count,
        ]
        
        if let captcha = self.recaptachToken {
            result["captcha"] = captcha
        }
        
        return result
    }
    
    var host: URL? {
        if let url = url,
            let uri = URL(string: url),
            let host = uri.host,
            let scheme = uri.scheme,
            let result = URL(string: "\(scheme)://\(host)") {
            return result
        }
        return nil
    }
    
    var path: String? {
        if let url = url, let uri = URL(string: url) {
            return uri.path
        }
        return nil
    }
}
