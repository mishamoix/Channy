//
//  ChanAXPhotosViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 21/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation


class ChanAXPhotosViewController: AXPhotosViewController {
    override func shareAction(_ barButtonItem: UIBarButtonItem) {
       
        guard  let photo = self.dataSource.photo(at: self.currentPhotoIndex), let image = self.networkIntegration.origianl(for: photo) else {
            return
        }
        
        if self.handleActionButtonTapped(photo: photo) {
            return
        }
        
//        let anyRepresentation: UIImage = image.jpegData(compressionQuality: 1.0)
//        if let imageData = photo.imageData {
//            anyRepresentation = imageData
//        } else if let image = photo.image {
//            anyRepresentation = image
//        }
        
//        guard let uAnyRepresentation = anyRepresentation else {
//            return
//        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
//        activityViewController.completionWithItemsHandler = { [weak self] (activityType, completed, returnedItems, activityError) in
//            
//            
//            guard let `self` = self else {
//                return
//            }
//            
//            if let activityType = activityType, completed {
////                if activityType == UIActivity.ActivityType.saveToCameraRoll {
////                    CameraPermissionManager.request()
////                }
//                self.actionCompleted(activityType: activityType, for: photo)
//            }
//            
//        }
        
        
        activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
        self.present(activityViewController, animated: true)
    
    }
}
