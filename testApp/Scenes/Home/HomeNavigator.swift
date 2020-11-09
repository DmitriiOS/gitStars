//
//  HomeNavigator.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import UIKit

protocol HomeNavigator {
    func toDetails(currentRepositoryInfo: CurrentRepositoryInfo)
}

final class DefaultHomeNavigator: HomeNavigator {

    private unowned var navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation
    
    func toDetails(currentRepositoryInfo: CurrentRepositoryInfo) {
        let vc = SecondConfigurator(navigationController: navigationController, currentRepositoryInfo: currentRepositoryInfo).configure()
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Declare here navigation actions

}

