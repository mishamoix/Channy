//
//  RoundedCornerView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 07/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    
    // MARK: Properties
    
    /// The color of the border line.
    @IBInspectable var borderColor: UIColor = UIColor.black
    
    /// The width of the border.
    @IBInspectable var borderWidth: CGFloat = 0
    
    /// The drawn corner radius.
    @IBInspectable var cornerRadius: CGFloat = 30
    
    /// The color that the rectangle will be filled with.
    @IBInspectable var fillColor: UIColor = UIColor.white
    
    // MARK: UIView Methods
    
    override func draw(_ rect: CGRect) {
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        borderColor.set()
        borderPath.fill()
        
        let fillRect = CGRect(x: borderWidth, y: borderWidth, width: bounds.width - (2 * borderWidth), height: bounds.height - (2 * borderWidth))
//        let fillRect = CGRect(borderWidth, borderWidth, bounds.width - (2 * borderWidth), bounds.height - (2 * borderWidth))
        let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: cornerRadius)
        fillColor.set()
        fillPath.fill()
    }
}
