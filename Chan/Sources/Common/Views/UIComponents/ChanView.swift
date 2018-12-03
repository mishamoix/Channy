//
//  ChanView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ChanView: UIView {

//    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
//    private var isPressed = false
    
//    func setupLongGesture() {
//        self.configureGestureRecognizer()
//    }
//
//    private func configureGestureRecognizer() {
//        // Long Press Gesture Recognizer
//        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
//        longPressGestureRecognizer?.minimumPressDuration = 0.1
//        longPressGestureRecognizer?.delegate = self
//        addGestureRecognizer(longPressGestureRecognizer!)
//    }
//
//    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
//        if gestureRecognizer.state == .began {
//            handleLongPressBegan()
//        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
//            handleLongPressEnded()
//        }
//    }
//
//    private func handleLongPressBegan() {
//        guard !isPressed else {
//            return
//        }
//
//        isPressed = true
//        UIView.animate(withDuration: 0.5,
//                       delay: 0.0,
//                       usingSpringWithDamping: 0.8,
//                       initialSpringVelocity: 0.2,
//                       options: .beginFromCurrentState,
//                       animations: {
//                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }, completion: nil)
//    }
//
//    private func handleLongPressEnded() {
//        guard isPressed else {
//            return
//        }
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0.0,
//                       usingSpringWithDamping: 0.4,
//                       initialSpringVelocity: 0.2,
//                       options: .beginFromCurrentState,
//                       animations: {
//                        self.transform = CGAffineTransform.identity
//        }) { (finished) in
//            self.isPressed = false
//        }
//    }

}

extension ChanView: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}
