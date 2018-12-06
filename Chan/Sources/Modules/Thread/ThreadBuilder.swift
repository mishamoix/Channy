//
//  ThreadBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 12.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol ThreadDependency: Dependency {
//    var threadIsRoot: Bool { get }
}

final class ThreadComponent: Component<ThreadDependency>, ThreadDependency, WriteDependency {
    var writeModuleState: WriteModuleState {
        return .write
    }
    

//    var threadIsRoot = false
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ThreadBuildable: Buildable {
    func build(withListener listener: ThreadListener, thread: ThreadModel) -> ThreadRouting
    func build(withListener listener: ThreadListener, replys: PostReplysViewModel) -> ThreadRouting
}

final class ThreadBuilder: Builder<ThreadDependency>, ThreadBuildable {

    override init(dependency: ThreadDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ThreadListener, thread: ThreadModel) -> ThreadRouting {
        let component = ThreadComponent(dependency: dependency)
//        component.threadIsRoot = false
        
        let viewController = UIStoryboard(name: "ThreadViewController", bundle: nil).instantiateViewController(withIdentifier: "ThreadViewController") as! ThreadViewController
        
        let service = ThreadService(thread: thread)
        let interactor = ThreadInteractor(presenter: viewController, service: service, moduleIsRoot: true)
        interactor.listener = listener
        
        let thread = ThreadBuilder(dependency: component)
        let write = WriteBuilder(dependency: component)
        
        return ThreadRouter(interactor: interactor, viewController: viewController, threadBuilder: thread, writeBuilder: write)
    }
    
    func build(withListener listener: ThreadListener, replys: PostReplysViewModel) -> ThreadRouting {
        let component = ThreadComponent(dependency: dependency)
//        component.threadIsRoot = false
        
        let viewController = UIStoryboard(name: "ThreadViewController", bundle: nil).instantiateViewController(withIdentifier: "ThreadViewController") as! ThreadViewController
        
        var service: ThreadServiceProtocol
        if let replyed = replys.replyed {
            service = ThreadRepledService(thread: replys.thread, parent: replys.parent, posts: replys.posts, replyed: replyed)
        } else {
            service = ThreadReplyService(thread: replys.thread, parent: replys.parent, posts: replys.posts)
        }
        
        let interactor = ThreadInteractor(presenter: viewController, service: service, moduleIsRoot:false, cachedVM: replys.cachedVM)
        interactor.listener = listener
        
        let thread = ThreadBuilder(dependency: component)
        
        return ThreadRouter(interactor: interactor, viewController: viewController, threadBuilder: thread)
    }
    
    
}
