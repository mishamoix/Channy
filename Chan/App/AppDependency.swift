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
import SwiftSoup

class AppDependency: NSObject {
    static var shared = AppDependency()
    private var launchRouter: LaunchRouting?

    var interfaceImageDownloader: ImageDownloader = ImageDownloader()

    func startApp(with window: UIWindow) {
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
        
        
//        test()
    }
    
    func test() {
        let text = "<a href=\"/b/res/183065082.html#183071189\" class=\"post-reply-link\" data-thread=\"183065082\" data-num=\"183071189\">>>183071189      </a> <span class=\"unkfunc\">>1          и как всегда <a href=\"/b/res/183065082.html#183071189\" class=\"post-reply-link\" data-thread=\"183065082\" data-num=\"183071189\">>>183071189</a> лучшие вет клиники в СШП</span>"
        
        PostPreparation(text: text, thread: "1", post: "2")
    }

    
  
}
