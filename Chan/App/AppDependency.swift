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

class AppDependency: NSObject {
    
    let disposeBag = DisposeBag()
    
    static var shared = AppDependency()
    private var launchRouter: LaunchRouting?

    var interfaceImageDownloader: ImageDownloader = ImageDownloader()

    func startApp(with window: UIWindow) {
        self.setupMainAppearance()
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
        
        
        
    }
    
    func setupMainAppearance() {
        UIBarButtonItem.appearance().tintColor = .main
    }
    

    


    
  
}
