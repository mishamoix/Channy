//
//  SettingsBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 29/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol SettingsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingsComponent: Component<SettingsDependency>, ProxyDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingsBuildable: Buildable {
    func build(withListener listener: SettingsListener) -> SettingsRouting
}

final class SettingsBuilder: Builder<SettingsDependency>, SettingsBuildable {

    override init(dependency: SettingsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingsListener) -> SettingsRouting {
        let component = SettingsComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "SettingsViewController", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener
        
        let proxyBuilder = ProxyBuilder(dependency: component)
        
        return SettingsRouter(interactor: interactor, viewController: viewController, proxyBuilable: proxyBuilder)
    }
}
