//
//  MainContainerViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

protocol MainContainerPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainContainerViewController: BaseTabBarController, MainContainerPresentable, MainContainerViewControllable {

    weak var listener: MainContainerPresentableListener?
    
    private var tabBarView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addTabs(views: [UIViewController]) {
        self.viewControllers = views
    }
    
    
    func openBoards() {
        self.selectedIndex = 0
    }
    
    
    // MARK: private
    
    
    
    private func setupUI() {
        let tabbar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tabBar.addSubview(tabbar)

        self.tabBarView = tabbar

        tabbar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.setupTheme()
        
        self.tabBar.tintColor = ThemeManager.shared.theme.accnt
    }
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self.tabBarView, type: .viewControllerBG, subtype: .none))
    }
}

extension MainContainerViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
