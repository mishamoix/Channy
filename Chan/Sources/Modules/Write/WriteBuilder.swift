//
//  WriteBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol WriteDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WriteComponent: Component<WriteDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol WriteBuildable: Buildable {
    func build(withListener listener: WriteListener, thread: ThreadModel) -> WriteRouting
}

final class WriteBuilder: Builder<WriteDependency>, WriteBuildable {

    override init(dependency: WriteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WriteListener, thread: ThreadModel) -> WriteRouting {
        let component = WriteComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "WriteViewController", bundle: nil).instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        let service = WriteService(thread: thread)
        
        let interactor = WriteInteractor(presenter: viewController, service: service)
        interactor.listener = listener
        return WriteRouter(interactor: interactor, viewController: viewController)
    }
}
