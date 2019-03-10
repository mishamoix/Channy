//
//  BaseView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    class func instance() -> Self {
        return BaseView.privateInstance(type: self)!
    }
    
    private class func privateInstance<T>(type: T.Type) -> T? {
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? T
        return view
    }

}
