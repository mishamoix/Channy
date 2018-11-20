//
//  AppDependency.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya
import RIBs
import AlamofireImage
import RxSwift
import Firebase
import FirebaseDatabase
import Fabric
import Crashlytics
import AVKit

enum AppAction {
    case willActive
}

class AppDependency: NSObject {
    
    let disposeBag = DisposeBag()
    
    static var shared = AppDependency()
    private var launchRouter: LaunchRouting?
    
    
    private let _appAction: PublishSubject<AppAction> = PublishSubject()
    var appAction: Observable<AppAction> {
        return self._appAction.asObservable()
    }

    var interfaceImageDownloader: ImageDownloader = ImageDownloader()

    func startApp(with window: UIWindow) {

        self.commonSetup()
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
    }
    
    func commonSetup() {
        self.setupMainAppearance()
        self.setupFirebase()
        
        FirebaseManager.setup()
      
        Fabric.with([Crashlytics.self])
        
        CoreDataStore.shared.setup()
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback, options: AVAudioSession.CategoryOptions.allowBluetoothA2DP)
            } else {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let copyOrigianlText = UIMenuItem(title: "Скопировать оригинал", action: Selector(("copyOrigianlText")))
        let copyText = UIMenuItem(title: "Скопировать", action: Selector(("copyText")))
        let copyLink = UIMenuItem(title: "Скопировать ссылку", action: Selector(("copyLink")))

        UIMenuController.shared.menuItems = [copyLink, copyText, copyOrigianlText]
        UIMenuController.shared.update()
        UIMenuController.shared.setMenuVisible(true, animated: true)

    }

    
    func setupMainAppearance() {
        UIBarButtonItem.appearance().tintColor = .main
        
    }
    
    func setupFirebase() {
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
    }
    
    func updateAction(app action: AppAction) {
        self._appAction.on(.next(action))
    }

    


    
  
}
