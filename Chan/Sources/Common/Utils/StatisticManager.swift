//
//  StatisticManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 07/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Firebase


class StatisticManager {
//
//  let shared = StatisticManager()
//  
//  init() {}
  
  
  class func event(name: String, values: [String:Any] = [:]) {
    Helper.performOnUtilityThread {
      Analytics.logEvent(name, parameters: values)
    }
  }
  
}
