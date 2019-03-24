//
//  ImageboardModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ImageboardModel: BaseModel, Decodable {
    
    enum CaptchaType: String {
        case noCaptcha
        case recaptchaV2 = "reCAPTCHA v2"
        
        var value: String? {
            switch self {
            case .noCaptcha:
                return nil
            case .recaptchaV2:
                return self.rawValue
            }
        }
        
        static func captchaType(with string: String?) -> CaptchaType {
            guard let _ = string else {
                return .noCaptcha
            }
            
            return .recaptchaV2
        }
    }
    
    class Captcha: BaseModel, Decodable {
        var type: CaptchaType = .noCaptcha
        var key: String? = nil
        
        init(type: String?, key: String?) {
            self.key = key
            self.type = CaptchaType.captchaType(with: type)
        }
        
        required convenience init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if let captchaKey = try? values.decode(String.self, forKey: .key), let captchaType = try? values.decode(String.self, forKey: .type) {
                self.init(type: captchaType, key: captchaKey)
            } else {
                self.init(type: nil, key: nil)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case key
            case type
        }
    }
    
    var id: Int = 0
    var name: String = ""
    
    var baseURL: URL? = nil
    var logo: URL? = nil
    var maxImages: Int = 4
    var highlight: UIColor? = nil
    var boards: [BoardModel] = [] {
        didSet {
            for board in boards {
                board.imageboard = self
            }
        }
    }
    
    var sort: Int = 0
    var current: Bool? = nil
    
    var captcha: ImageboardModel.Captcha?
    
    override init() {
        super.init()
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case baseURL
        case logo
        case maxImages
        case highlight
        
        case captcha
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? values.decode(Int.self, forKey: .id) {
            self.id = id
        }
        
        if let name = try? values.decode(String.self, forKey: .name) {
            self.name = name
        }
        
        if let baseUrl = try? values.decode(String.self, forKey: .baseURL) {
            self.baseURL = URL(string: baseUrl)
        }
        
        if let logo = try? values.decode(String.self, forKey: .logo) {
            self.logo = URL(string: logo)
        }
        
        if let maxImages = try? values.decode(Int.self, forKey: .maxImages) {
            self.maxImages = maxImages
        }
        
        if let highlight = try? values.decode(String.self, forKey: .highlight) {
            self.highlight = UIColor(hex: highlight) ?? UIColor.main
        }
        
        if let captcha = try? values.decode(ImageboardModel.Captcha.self, forKey: .captcha) {
            self.captcha = captcha
        }
        
    }

}
