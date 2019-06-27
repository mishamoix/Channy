
//
//  WriteImagePicker.swift
//  Chan
//
//  Created by Mikhail Malyshev on 03/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift
import CoreServices

class WriteImagePicker: NSObject {
    private let picker = UIImagePickerController()
    private let publish = PublishSubject<UIImage?>()
    
    override init() {
        super.init()
        
        self.picker.delegate = self
        self.picker.allowsEditing = false
        self.picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.picker.mediaTypes = [kUTTypeImage as String]
    }
    
    
    func pickImage(from vc: UIViewController) -> Observable<UIImage?> {
//        CameraPermissionManager.request()
        
        vc.present(self.picker, animated: true, completion: nil)
        
        return self
            .publish
            .map({ [weak self] image -> UIImage? in
                if let self = self {
                    self.picker.dismiss(animated: true, completion: nil)
                }
                return image
            })
            .asObservable()
    }
}

extension WriteImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.publish.on(.next(nil))
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.publish.on(.next(image))
    }
    
//    imageP
}
