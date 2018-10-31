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

final class BoardComponent: Component<BoardDependency>, ThreadDependency, BoardsListDependency, WebAcceptDependency {

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
        let boardListBuilder = BoardsListBuilder(dependency: component)
        let agreement = WebAcceptBuilder(dependency: component)

        
        return BoardRouter(interactor: interactor, viewController: viewController, thread: threadBuilder, boardList: boardListBuilder, agreement: agreement)
    }
}
