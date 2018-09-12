//
//  BoardsListBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardsListDependency: Dependency, BoardDependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BoardsListComponent: Component<BoardsListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BoardsListBuildable: Buildable {
    func build(withListener listener: BoardsListListener) -> BoardsListRouting
}

final class BoardsListBuilder: Builder<BoardsListDependency>, BoardsListBuildable {

    override init(dependency: BoardsListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BoardsListListener) -> BoardsListRouting {
        let component = BoardsListComponent(dependency: dependency)
        let viewController = UIStoryboard(name: "BoardsListViewController", bundle: nil).instantiateViewController(withIdentifier: "BoardsListViewController") as! BoardsListViewController
        
        let interactor = self.buildInteractor(vc: viewController)
        interactor.listener = listener
        
        let board = BoardBuilder(dependency: self.dependency)
        
        return BoardsListRouter(interactor: interactor, viewController: viewController, board: board)
    }
    
    // MARK: Private
    private func buildInteractor(vc viewController: BoardsListPresentable) -> BoardsListInteractor {
        
        let list = BoardsListService()
        
        let interactor = BoardsListInteractor(presenter: viewController, list: list)
        return interactor
    }
}
