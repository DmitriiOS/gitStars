//
//  HomeNavigator.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import UIKit

protocol HomeNavigator {
    func toDetails(receivedDatesAndStars: [DatesAndStars])
}

final class DefaultHomeNavigator: HomeNavigator {

    private unowned var navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation
    
    func toDetails(receivedDatesAndStars: [DatesAndStars]) {
        let vc = SecondConfigurator(navigationController: navigationController, receivedDatesAndStars: receivedDatesAndStars).configure()
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Declare here navigation actions

}

