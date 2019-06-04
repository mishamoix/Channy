//
//  WriteBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol WriteDependency: Dependency {
  var writeModuleState: WriteModuleState { get }
}

final class WriteComponent: Component<WriteDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol WriteBuildable: Buildable {
    func build(withListener listener: WriteListener, thread: ThreadModel, data: Observable<String>?) -> WriteRouting
}

final class WriteBuilder: Builder<WriteDependency>, WriteBuildable {

    override init(dependency: WriteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WriteListener, thread: ThreadModel, data: Observable<String>?) -> WriteRouting {
        let component = WriteComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "WriteViewController", bundle: nil).instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        viewController.data = data
        
        let service = WriteService(thread: thread)
        let imageboardService = ImageboardService.instance()
        
        let interactor = WriteInteractor(presenter: viewController, service: service, imageboardService: imageboardService, state: dependency.writeModuleState)
        interactor.listener = listener
        return WriteRouter(interactor: interactor, viewController: viewController)
    }
}
