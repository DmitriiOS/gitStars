//
//  SecondNavigator.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import UIKit

protocol SecondNavigator {
    
}

final class DefaultSecondNavigator: SecondNavigator {

    private unowned var navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation
    
    // Declare here navigation actions

}
