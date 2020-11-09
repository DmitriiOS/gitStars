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
    private var currentRepositoryInfo: CurrentRepositoryInfo
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController, currentRepositoryInfo: CurrentRepositoryInfo) {
        self.navigationController = navigationController
        self.currentRepositoryInfo = currentRepositoryInfo
    }
    
    // MARK: - Configuration
    
    func configure() -> UIViewController {
        let vc = storyboard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        let navigator = DefaultSecondNavigator(navigationController: navigationController)
        let storage = RealmStorage()
        let gitStarService = GitStarService(storage: storage)
        let starDatesService = StarDatesService()
        vc.presenter = SecondPresenter(view: vc,
                                       navigator: navigator,
                                       currentRepositoryInfo: currentRepositoryInfo,
                                       gitStarService: gitStarService,
                                       starDatesService: starDatesService)
        return vc
    }
}

// swiftlint:enable force_cast
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
