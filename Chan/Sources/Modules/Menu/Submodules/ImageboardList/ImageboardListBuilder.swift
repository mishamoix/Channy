//
//  ImageboardListBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ImageboardListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ImageboardListComponent: Component<ImageboardListDependency>, SettingsDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ImageboardListBuildable: Buildable {
    func build(withListener listener: ImageboardListListener) -> ImageboardListRouting
}

final class ImageboardListBuilder: Builder<ImageboardListDependency>, ImageboardListBuildable {

    override init(dependency: ImageboardListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ImageboardListListener) -> ImageboardListRouting {
        let component = ImageboardListComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "ImageboardListViewController", bundle: nil).instantiateViewController(withIdentifier: "ImageboardListViewController") as! ImageboardListViewController
        
        let service = ImageboardService.instance()
        
        let interactor = ImageboardListInteractor(presenter: viewController, service: service)
        interactor.listener = listener
        
        let settings = SettingsBuilder(dependency: component)
        return ImageboardListRouter(interactor: interactor, viewController: viewController, settings: settings)
    }
}
