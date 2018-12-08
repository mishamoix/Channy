//
//  ChanAXPhotosViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 21/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import AXPhotoViewer


class ChanAXPhotosViewController: AXPhotosViewController {
    override func shareAction(_ barButtonItem: UIBarButtonItem) {
       
        guard  let photo = self.dataSource.photo(at: self.currentPhotoIndex), let image = self.networkIntegration.origianl(for: photo) else {
            return
        }
        
        if self.handleActionButtonTapped(photo: photo) {
            return
        }
        
        let anyRepresentation: Any? = image.jpegData(compressionQuality: 1.0)
//        if let imageData = photo.imageData {
//            anyRepresentation = imageData
//        } else if let image = photo.image {
//            anyRepresentation = image
//        }
        
        guard let uAnyRepresentation = anyRepresentation else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [uAnyRepresentation], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { [weak self] (activityType, completed, returnedItems, activityError) in
            
            
            guard let `self` = self else {
                return
            }
            
            if completed, let activityType = activityType {
                if activityType == UIActivity.ActivityType.saveToCameraRoll {
                    CameraPermissionManager.request()
                }
                self.actionCompleted(activityType: activityType, for: photo)
            }
            
        }
        
        
        activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
        self.present(activityViewController, animated: true)
    
    }
}
