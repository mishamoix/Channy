//
//  CameraPermissionManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 21/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class CameraPermissionManager {
  
  private static let disposeBag = DisposeBag()
  
  
  static func request(callback: (() -> ())? = nil) {
    let photos = PHPhotoLibrary.authorizationStatus()

    let block: () -> () = {
      let photos = PHPhotoLibrary.authorizationStatus()

      if photos != .authorized {
        let alert = ChanError.error(title: "gallery_no_access".localized, description: "gallery_access_instructions".localized)
        let display = ErrorDisplay(error: alert, buttons: [ErrorButton.cancel, ErrorButton.custom(title: "Settings".localized, style: UIAlertAction.Style.default)])
        display.show()
        
        display
          .actions
          .subscribe(onNext: { action in
            switch action {
            case .custom(_, _):
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    callback?()
                    return
                }
            
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }

            default: break
            }
            
            callback?()
          })
          .disposed(by: CameraPermissionManager.disposeBag)
      } else {
        callback?()
      }
    }
    
    if photos == .notDetermined {
        PHPhotoLibrary.requestAuthorization { _ in
            block()
        }
    } else {
        block()
    }
    
    
  }
  
}
