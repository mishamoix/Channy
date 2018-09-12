//
//  ThreadBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ThreadDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ThreadComponent: Component<ThreadDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ThreadBuildable: Buildable {
    func build(withListener listener: ThreadListener, thread: ThreadModel) -> ThreadRouting
}

final class ThreadBuilder: Builder<ThreadDependency>, ThreadBuildable {

    override init(dependency: ThreadDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ThreadListener, thread: ThreadModel) -> ThreadRouting {
        let component = ThreadComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "ThreadViewController", bundle: nil).instantiateViewController(withIdentifier: "ThreadViewController") as! ThreadViewController
        
        let service = ThreadService(thread: thread)
        let interactor = ThreadInteractor(presenter: viewController, service: service)
        interactor.listener = listener
        return ThreadRouter(interactor: interactor, viewController: viewController)
    }
}
