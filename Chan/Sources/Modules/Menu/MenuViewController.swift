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
import SnapKit

protocol MenuPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MenuViewController: BaseViewController, MenuPresentable, MenuViewControllable {

    weak var listener: MenuPresentableListener?
    private let scrollView = UIScrollView()
    private let pageIndicator = UIPageControl(frame: .zero)
    
    var views: [UIViewController] = [] {
        didSet {
            self.pageIndicator.numberOfPages = self.views.count
        }
    }
    
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var offset: CGFloat = 0
        for vc in views {
            
            vc.view.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(offset)
                make.size.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
//            vc.view.frame = CGRect(x: offset, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            offset += self.view.frame.width
        }
        
        self.scrollView.contentSize = CGSize(width: offset, height: self.view.frame.height)
    }

    
    func setup(views: [UIViewController]) {
        self.loadViewIfNeeded()
        self.views = views
        
        for vc in views {
            vc.willMove(toParent: self)
            self.addChild(vc)
            self.scrollView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        
        

    }
    
    func select(page idx: Int) {
//        self.pageIndicator
    }
    
    // MARK: Private
    private func setup() {
        self.setupUI()
        
    }
    
    
    private func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(self.scrollView)
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.bounces = false
        self.scrollView.frame = self.view.bounds
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.scrollView.showsHorizontalScrollIndicator = false
        
        
        self.view.addSubview(self.pageIndicator)
        
        
        var bottomOffset = MenuIndicatorBottomOffset
        
        if #available(iOS 11.0, *) {
            bottomOffset += self.view.safeAreaInsets.bottom
        }
        
        self.pageIndicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-bottomOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(MenuIndicatorHeight)
            make.width.equalTo(MenuIndicatorWidth)
        }
        self.pageIndicator.layer.cornerRadius = MenuIndicatorCornerRadius
        self.pageIndicator.backgroundColor = UIColor.gray
    }
}


extension MenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == 0) {
            self.pageIndicator.currentPage = 0
        } else {
            let idx = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            self.pageIndicator.currentPage = idx
        }
    }
}
