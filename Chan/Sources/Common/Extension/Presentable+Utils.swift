//
//  Presentable+Utils.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import RIBs
import MBProgressHUD

public protocol ViewRefreshing {
    func endRefresh()
    func startRefresh()
}


public extension Presentable {
    
    func showCentralActivity() {
        Helper.performOnMainThread {
            if let view = (self as? UIViewController)?.view {
                MBProgressHUD.showAdded(to: view, animated: true)
            }
            
        }

    }
    
    private func hideCentralActivity() {
        Helper.performOnMainThread {
            if let view = (self as? UIViewController)?.view {
                MBProgressHUD.hide(for: view, animated: true)
            }
            
        }

    }
    
    
    private func startRefreshing() {
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
    
    private func endRefreshing() {
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
    
    func stopAnyLoaders() {
        self.hideCentralActivity()
        self.endRefreshing()
    }
}
