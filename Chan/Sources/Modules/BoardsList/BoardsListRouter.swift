//
//  BoardsListRouter.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs

protocol BoardsListInteractable: Interactable, BoardListener, SettingsListener, WebAcceptListener {
    var router: BoardsListRouting? { get set }
    var listener: BoardsListListener? { get set }
}

protocol BoardsListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BoardsListRouter: ViewableRouter<BoardsListInteractable, BoardsListViewControllable>, BoardsListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: BoardsListInteractable, viewController: BoardsListViewControllable, settings: SettingsBuildable) {
//        self.boardBuildable = board
        self.settingsBuildable = settings
//        self.agreementBuildable = agreement
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: BoardsListRouting
//    func openBoard(with board: BoardModel) {
//
//        self.tryDeattach(router: self.board) {
//            let board = self.boardBuildable.build(withListener: self.interactor, board: board)
//            self.attachChild(board)
//            self.board = board
//
//            self.viewController.push(view: board.viewControllable)
//
//        }
//
//    }
//
    func openSettings() {
        self.tryDeattach(router: self.setting) {
            let setting = self.settingsBuildable.build(withListener: self.interactor)
            self.attachChild(setting)
            self.setting = setting

            self.viewController.push(view: setting.viewControllable)
        }
    }
//
//    func openAgreement(model: WebAcceptViewModel) {
//        self.closeAgreement()
//        self.tryDeattach(router: self.agreement) {
//            let agreement = self.agreementBuildable.build(withListener: self.interactor, model: model)
//            self.agreement = agreement
//            self.attachChild(agreement)
//
//            self.viewController.present(view: agreement.viewControllable)
//        }
//    }
//
//    func closeAgreement() {
//        self.agreement?.viewControllable.dismiss()
//        self.tryDeattach(router: self.agreement) {
//            self.agreement = nil
//        }
//    }
//
    
    
    // MARK: Private
//    private let boardBuildable: BoardBuildable
//    private weak var board: ViewableRouting?
//
    private let settingsBuildable: SettingsBuildable
    private weak var setting: ViewableRouting?
//


}
