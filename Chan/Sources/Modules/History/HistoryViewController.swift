//
//  HistoryViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 26/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol HistoryPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HistoryViewController: UIViewController, HistoryPresentable, HistoryViewControllable {

    weak var listener: HistoryPresentableListener?
}
