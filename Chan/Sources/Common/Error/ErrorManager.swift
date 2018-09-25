//
//  ErrorManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 25/09/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RIBs

class ErrorManager {
    static func errorHandler(for interactor: Interactor?, error: Error, actions: [ErrorButton] = [.ok]) -> ErrorDisplayProtocol {
        return ErrorDisplay(error: error, buttons: actions)
    }
}
