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
  
    public let text: String
    public let font: UIFont
    public let maxWidth: CGFloat
    public let attributedString: NSAttributedString
    public let lineHeight: CGFloat?
  
  public init(text: String, maxWidth: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) {
    self.maxWidth = maxWidth
    self.text = TextSize.prepareText(text)
    self.font = font
    self.lineHeight = lineHeight
    
    self.attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : font])
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
    
    static func indexForPoint(text: NSAttributedString?, point: CGPoint, container size: CGSize) -> Int {
      guard let text = text else {
        return 0
      }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: text)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = 0
        let labelSize = size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = point
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x, y: locationOfTouchInLabel.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return indexOfCharacter
    }
  
  private static func prepareText(_ text: String) -> String {
    var result = text
    if (result.last == "\n") {
      result += "0"
    }
    return result

  }
    
    
}
