//
//  HomeConfigurator.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
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
        vc.presenter = HomePresenter(view: vc,
                                     navigator: navigator,
                                     gitService: gitService)
        return navigationController
    }
}

// swiftlint:enable force_cast
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
