//
//  MenuViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol MenuPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MenuViewController: UIPageViewController, MenuPresentable, MenuViewControllable {

    weak var listener: MenuPresentableListener?
    
    var views: [UIViewController] = []
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    
    
    // MARK: Private
    private func setup() {
        
        self.dataSource = self
        
        self.setupUI()
        
    }
    
    
    private func setupUI() {
        
        let first = UIViewController()
        first.view.backgroundColor = .green
        
        let second = UIViewController()
        second.view.backgroundColor = .blue
        
        
        self.views = [first, second]
    
        self.setViewControllers([second], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        

    }
}


extension MenuViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController == self.views.last!) {
            return self.views.first!
        }
        
        return nil
    }
    
    @available(iOS 5.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController == self.views.first!) {
            return self.views.last!
        }
        
        return nil
    }
}
