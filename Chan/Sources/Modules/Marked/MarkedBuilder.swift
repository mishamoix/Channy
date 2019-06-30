//
//  MarkedBuilder.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs


enum MarkedModuleType {
    case history
    case favorited
}

protocol MarkedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MarkedComponent: Component<MarkedDependency> {
    
    let type: MarkedModuleType
    
    init(dependency: MarkedDependency, type: MarkedModuleType) {
        self.type = type
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MarkedBuildable: Buildable {
    func buildHistory(withListener listener: MarkedListener) -> MarkedRouting
    func buildFavorited(withListener listener: MarkedListener) -> MarkedRouting
}

final class MarkedBuilder: Builder<MarkedDependency>, MarkedBuildable {
    
    override init(dependency: MarkedDependency) {
        super.init(dependency: dependency)
    }

    func buildHistory(withListener listener: MarkedListener) -> MarkedRouting {
        let service = HistoryService()
        return self.baseBuild(read: service, withListener: listener, type: .history)
    }
    
    func buildFavorited(withListener listener: MarkedListener) -> MarkedRouting {
        let service = FavoriteService()
        
        return self.baseBuild(read: service, withListener: listener, type: .favorited)
    }
    
    
    private func baseBuild(read service: ReadMarkServiceProtocol, withListener listener: MarkedListener, type: MarkedModuleType) -> MarkedRouting {
        let component = MarkedComponent(dependency: dependency, type: type)
        let viewController = UIStoryboard(name: "MarkedViewController", bundle: nil).instantiateViewController(withIdentifier: "MarkedViewController") as! MarkedViewController
        viewController.component = component
        let interactor = MarkedInteractor(presenter: viewController, service: service)
        interactor.listener = listener
        return MarkedRouter(interactor: interactor, viewController: viewController)

    }
}
