//
//  HomeNavigator.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import UIKit

protocol HomeNavigator {
    func toDetails(receivedDatesAndStars: [DatesAndStars], ofGitData: String, gitLogin: String)
}

final class DefaultHomeNavigator: HomeNavigator {

    private unowned var navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation
    
    func toDetails(receivedDatesAndStars: [DatesAndStars], ofGitData: String, gitLogin: String) {
        let vc = SecondConfigurator(navigationController: navigationController, datesAndStars: receivedDatesAndStars, receivedGitRepo: ofGitData, receivedGitLogin: gitLogin).configure()
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Declare here navigation actions

}

