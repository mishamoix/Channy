//
//  OnboardViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol OnboardPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OnboardViewController: UIViewController, OnboardPresentable, OnboardViewControllable {

    weak var listener: OnboardPresentableListener?
    private let onboard = SwiftyOnboard(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.setupOnboard()
    }
    
    private func setupRx() {
        
    }
    
    private func setupOnboard() {
        self.onboard.frame = self.view.bounds
        self.view.addSubview(self.onboard)
        self.onboard.dataSource = self
        self.onboard.shouldSwipe = true
    }
}

extension OnboardViewController: SwiftyOnboardDataSource {
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3

    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        page.imageView.image = UIImage(named: "onboard1")
        return page
    }
    
}
