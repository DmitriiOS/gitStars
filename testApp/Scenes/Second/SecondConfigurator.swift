//
//  SecondConfigurator.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import UIKit

// swiftlint:disable force_cast
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

final class SecondConfigurator {
    
    private let storyboard = UIStoryboard(name: "Second", bundle: nil)
    private var navigationController: UINavigationController
    private var receivedGitRepo: String
    private var receivedGitLogin: String
    private var datesAndStars: [DatesAndStars]
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController, datesAndStars: [DatesAndStars], receivedGitRepo: String, receivedGitLogin: String) {
        self.navigationController = navigationController
        self.datesAndStars = datesAndStars
        self.receivedGitRepo = receivedGitRepo
        self.receivedGitLogin = receivedGitLogin
    }
    
    // MARK: - Configuration
    
    func configure() -> UIViewController {
        let vc = storyboard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        let navigator = DefaultSecondNavigator(navigationController: navigationController)
        vc.presenter = SecondPresenter(view: vc,
                                       navigator: navigator,
                                       datesAndStars: datesAndStars,
                                       receivedGitRepo: receivedGitRepo,
                                       receivedGitLogin: receivedGitLogin)
        return vc
    }
}

// swiftlint:enable force_cast
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
