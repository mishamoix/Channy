//
//  TextSize.swift
//  Magazin Remontov
//
//  Created by Mikhail Malyshev on 16.04.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Foundation

open class TextSize {
  
  open let text: String
  open let font: UIFont
  open let maxWidth: CGFloat
  open let attributedString: NSAttributedString
  open let lineHeight: CGFloat?
  
  public init(text: String, maxWidth: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) {
    self.maxWidth = maxWidth
    self.text = TextSize.prepareText(text)
    self.font = font
    self.lineHeight = lineHeight
    
    self.attributedString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : font])
  }
  
//  public init(attributed: NSAttributedString, maxWidth: CGFloat, lineHeight: CGFloat? = nil) {
//    self.maxWidth = maxWidth
//    self.text = attributed.string
//    self.font = .chatText
//    self.attributedString = attributed
//    self.lineHeight = lineHeight
//  }

  open func calculate() -> CGSize {
    let data = TGReusableLabel.calculateLayout(self.text, additionalAttributes: [], textCheckingResults: [], font: self.font, textColor: .white, frame: CGRect(x: 0, y: 0, width: self.maxWidth, height: CGFloat.infinity), orMaxWidth: Float(self.maxWidth), flags: Int32(TGReusableLabelLayoutMultiline.rawValue), textAlignment: NSTextAlignment.left, outIsRTL: nil)
    
    if let data = data {
      let size = CGSize(width: data.drawingSize().width, height: CGFloat(data.textLines.count) * (self.lineHeight ?? self.font.lineHeight))
      
      return size
    }
    
    return .zero
  }
  
  open func oldCalculate() -> CGSize {
    
    let storage = NSTextStorage(attributedString: self.attributedString)
    let textContainer = NSTextContainer(size: CGSize(width: self.maxWidth, height: CGFloat(Float.greatestFiniteMagnitude)))
    let layoutManager = NSLayoutManager()
    
    layoutManager.addTextContainer(textContainer)
    storage.addLayoutManager(layoutManager)
    textContainer.lineFragmentPadding = 0
    
    layoutManager.glyphRange(for: textContainer)
    let result = layoutManager.usedRect(for: textContainer).size
    let height = result.height
    return CGSize(width: CGFloat(ceilf(Float((result.width)))), height: CGFloat(ceilf(Float(height))))
  }
  
  private static func prepareText(_ text: String) -> String {
    var result = text
    if (result.last == "\n") {
      result += "0"
    }
    return result

  }
}
