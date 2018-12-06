//
//  WriteConstants.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

enum WriteModuleState {
  case write
  case create
}

enum WriteViewActions {
    case send(text: String?)
}
