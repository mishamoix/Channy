//
//  ImageboardListRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ImageboardListInteractable: Interactable, SettingsListener {
    var router: ImageboardListRouting? { get set }
    var listener: ImageboardListListener? { get set }
}

protocol ImageboardListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ImageboardListRouter: ViewableRouter<ImageboardListInteractable, ImageboardListViewControllable>, ImageboardListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: ImageboardListInteractable, viewController: ImageboardListViewControllable, settings: SettingsBuildable) {
        self.settingsBuildable = settings
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    private let settingsBuildable: SettingsBuildable
    private weak var setting: ViewableRouting?

    
    
    // MARK: ImageboardListPresentable
    func settingTapped() {
        self.tryDeattach(router: self.setting) {
            let setting = self.settingsBuildable.build(withListener: self.interactor)
            self.attachChild(setting)
            self.setting = setting
            
            let nc = BaseNavigationController(rootViewController: setting.viewControllable.uiviewController)
            self.viewController.present(vc: nc)
        }
    }
}
