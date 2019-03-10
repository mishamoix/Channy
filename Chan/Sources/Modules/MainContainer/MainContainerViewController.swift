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
    
    func addTab(view: UIViewController) {
        let test = UITabBarItem(title: "", image: nil, selectedImage: nil)
        
        view.tabBarItem = test
        
        
        let vc = UIViewController()
        let test2 =  UITabBarItem(title: "", image: nil, selectedImage: nil)
        vc.tabBarItem = test2
        
        self.viewControllers = [view, vc]
    }
    
    // MARK: private
    
    private func setupUI() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        view.backgroundColor = .red
        self.tabBar.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}

extension MainContainerViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
