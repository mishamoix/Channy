//
//  Presentable+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RIBs

public protocol ViewRefreshing {
    func endRefresh()
    func startRefresh()
}


public extension Presentable {
    func startRefreshing() {
        Helper.performOnMainThread {
            if let view = (self as? UIViewController)?.view {
                let scrollViews: [UIScrollView] = view.subviews.filter({ $0.isKind(of: UIScrollView.self) }) as! [UIScrollView]
                let _ = scrollViews.map({ $0.refreshControl?.beginRefreshing() })
            }
            
            if let vc = self as? ViewRefreshing {
                vc.startRefresh()
            }
        }
    }
    
    func endRefreshing() {
        Helper.performOnMainThread {
            if let view = (self as? UIViewController)?.view {
                let scrollViews: [UIScrollView] = view.subviews.filter({ $0.isKind(of: UIScrollView.self) }) as! [UIScrollView]
                let _ = scrollViews.map({ $0.refreshControl?.endRefreshing() })
            }
            
            if let vc = self as? ViewRefreshing {
                vc.endRefresh()
            }
        }
    }
}
