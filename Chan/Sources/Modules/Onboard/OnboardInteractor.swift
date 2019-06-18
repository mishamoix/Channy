//
//  OnboardInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 01/11/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol OnboardRouting: ViewableRouting {
    func openWebView(model: WebAcceptViewModel)
    func closeWebView()
    
}

protocol OnboardPresentable: Presentable {
    var listener: OnboardPresentableListener? { get set }

    func acceptToS()
    func acceptPrivacy()
}

protocol OnboardListener: class {
    func closeOnboarding()
}

enum CurrentOpen {
    case tos
    case privacy
}

final class OnboardInteractor: PresentableInteractor<OnboardPresentable>, OnboardInteractable, OnboardPresentableListener {

    weak var router: OnboardRouting?
    weak var listener: OnboardListener?
    private var currentOpen: CurrentOpen = .tos
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OnboardPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    var onboards: [OnboardViewModel] {
        var result: [OnboardViewModel] = []

        //        "lets_go" = "Поехали!";
        result.append(OnboardViewModel(title: "Anonymous".localized, subtitle: "anonymous_message".localized, image: .onboardingAnon))
        result.append(OnboardViewModel(title: "like_web".localized, subtitle: "like_web_message".localized, image: .onboardingFavorites))
        result.append(OnboardViewModel(title: "more_colors".localized, subtitle: "more_colors_message".localized, image: .onboardingTheme))
        result.append(OnboardViewModel(title: "safe_browsing".localized, subtitle: "safe_browsing_message".localized, image: .onboardingHat))
        result.append(OnboardViewModel(title: "lets_go".localized, subtitle: "", image: .onboardingLegion, type: .last))
        
        
        return result
    }
    
    func openToS() {
        self.currentOpen = .tos
        
        self.router?.openWebView(model: WebAcceptViewModel(url: FirebaseManager.shared.agreementUrl!, title: "term_of_service".localized))
    }
    
    func openPrivacy() {
        self.currentOpen = .privacy
        
        self.router?.openWebView(model: WebAcceptViewModel(url: FirebaseManager.shared.privacyUrl!, title: "privacy_policy".localized))

    }
    
    func close() {
        Values.shared.onboardShows = true
        self.listener?.closeOnboarding()
    }
    
    func accept() {
        self.router?.closeWebView()
        
        if self.currentOpen == .tos {
            self.presenter.acceptToS()
        } else {
            self.presenter.acceptPrivacy()
        }
    }
}
