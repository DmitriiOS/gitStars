//
//  SecondConfigurator.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import UIKit

// swiftlint:disable force_cast
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

final class SecondConfigurator {
    
    private let storyboard = UIStoryboard(name: "Second", bundle: nil)
    private var navigationController: UINavigationController
//    private var receivedGitRepo: String
//    private var receivedGitLogin: String
    private var datesAndStars: [DatesAndStars] = []
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController, datesAndStars: [DatesAndStars]) {
        self.navigationController = navigationController
        self.datesAndStars = datesAndStars
//        self.receivedGitRepo = receivedGitRepo
//        self.receivedGitLogin = receivedGitLogin
    }
    
    // MARK: - Configuration
    
    func configure() -> UIViewController {
        let vc = storyboard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        let navigator = DefaultSecondNavigator(navigationController: navigationController)
        let gitStarService = GitStarService()
        let starDatesService = StarDatesService()
        
        vc.presenter = SecondPresenter(view: vc, navigator: navigator, datesAndStars: datesAndStars, gitStarService: gitStarService, starDatesService: starDatesService)
        
        return vc
    }
}

// swiftlint:enable force_cast
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
