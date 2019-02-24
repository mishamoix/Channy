//
//  BoardBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardDependency: Dependency {
}

final class BoardComponent: Component<BoardDependency>, ThreadDependency, BoardsListDependency, WebAcceptDependency, WriteDependency {
    var writeModuleState: WriteModuleState { return .create }

}

// MARK: - Builder

protocol BoardBuildable: Buildable {
    func build(withListener listener: BoardListener) -> BoardRouting
}

final class BoardBuilder: Builder<BoardDependency>, BoardBuildable {

    override init(dependency: BoardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BoardListener) -> BoardRouting {
        let component = BoardComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "BoardViewController", bundle: nil).instantiateViewController(withIdentifier: "BoardViewController") as! BoardViewController
        
        let service = BoardService()
        let interactor = BoardInteractor(presenter: viewController, service: service)
        interactor.listener = listener
        
        let threadBuilder = ThreadBuilder(dependency: component)
        let agreement = WebAcceptBuilder(dependency: component)
        let createThread = WriteBuilder(dependency: component)
        
        return BoardRouter(interactor: interactor, viewController: viewController, thread: threadBuilder, agreement: agreement, createThread: createThread)
    }
}
