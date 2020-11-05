//
//  HomeConfigurator.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import UIKit

// swiftlint:disable force_cast
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

final class HomeConfigurator {
    
    private let storyboard = UIStoryboard(name: "Home", bundle: nil)
    
    // MARK: - Lifecycle
    
    // MARK: - Configuration
    
    func configure() -> UIViewController {
        let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        let navigationController = UINavigationController(rootViewController: vc)
        let navigator = DefaultHomeNavigator(navigationController: navigationController)
        let storage = RealmStorage()
        let gitService = GitService(storage: storage)
        let gitStarService = GitStarService(storage: storage)
        let starDatesService = StarDatesService()
      

        vc.presenter = HomePresenter(view: vc,
                                     navigator: navigator,
                                     gitService: gitService,
                                     gitStarService: gitStarService,
                                     starDatesService: starDatesService)
        
        return navigationController
    }
}

// swiftlint:enable force_cast
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
