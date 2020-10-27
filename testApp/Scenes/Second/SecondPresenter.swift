//
//  SecondPresenter.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import  Foundation

protocol GetDataFromHomeVC: AnyObject {
    func getLoginRepoDatesStars(datesStars: [DatesAndStars], login: String, repository: String)
}

protocol SecondView: AnyObject {
    func showReceivedData(repo receivedGitRepo: String, login receivedGitLogin: String)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
}

final class SecondPresenter {

	private unowned var view: GetDataFromHomeVC
	private let navigator: SecondNavigator
    private var datesAndStars: [DatesAndStars] = []
    private var receivedGitRepo: String
    private var receivedGitLogin: String
    

	// MARK: - Lifecycle

    init(view: GetDataFromHomeVC,
         navigator: SecondNavigator,
         datesAndStars: [DatesAndStars],
         receivedGitRepo: String,
         receivedGitLogin: String) {
		self.view = view
		self.navigator = navigator
        self.datesAndStars = datesAndStars
        self.receivedGitRepo = receivedGitRepo
        self.receivedGitLogin = receivedGitLogin
	}


	// MARK: - Actions

    func viewWillAppear() {
        view.getLoginRepoDatesStars(datesStars: datesAndStars, login: receivedGitLogin, repository: receivedGitRepo)
    }
    
    // MARK: - Internal actions
    
    
    // Declare here actions and handlers for events of the View
}
