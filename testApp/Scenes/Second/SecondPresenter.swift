//
//  SecondPresenter.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import  Foundation

protocol SecondView: AnyObject {
    func showReceivedData(repo receivedGitRepo: String, login receivedGitLogin: String)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
}

final class SecondPresenter {

	private unowned var view: SecondView
	private let navigator: SecondNavigator
    private var gitStarService: GitStarService
    
    var starDatesService: StarDatesService
    
    private var myRepoStars: [RepoStarsByDates] = []
    private var datesAndStars: [DatesAndStars] = []
    
    private var receivedGitRepo: String
    
    private var receivedGitLogin: String
    

	// MARK: - Lifecycle

    init(view: SecondView, navigator: SecondNavigator, receivedGitRepo: String, receivedGitLogin: String, gitStarService: GitStarService, starDatesService: StarDatesService) {
		self.view = view
		self.navigator = navigator
//        self.receivedGitRepo = receivedGitRepo
//        self.receivedGitLogin = receivedGitLogin
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
	}


	// MARK: - Actions
    
    let dispatchGroup = DispatchGroup()
    
    func fetchData() {
        dispatchGroup.enter()
        onPathComponentsReceived(login: receivedGitLogin, repo: receivedGitRepo)
        view.showReceivedData(repo: receivedGitRepo, login: receivedGitLogin)

        dispatchGroup.leave()
    }

    func viewWillAppear() {

        fetchData()
        dispatchGroup.notify(queue: .main) {
            self.reloadStarDates()
        }
    }
    
    func onPathComponentsReceived(login: String, repo: String) {
        let receivedLogin = login
        let receivedRepo = repo
        gitStarService.getGitRepoData(login: receivedLogin, repo: receivedRepo)
    }
    
    // MARK: - Internal actions

    func reloadStarDates() {
        self.gitStarService.loadRepoDates { [weak self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let myRepoStars):
                DispatchQueue.main.async {
                    self?.showRepoStars(myRepoStars)
                }
            }
        }
    }
    
    private func showRepoStars(_ dates: [RepoStarsByDates]) {
        self.myRepoStars = dates
        
        let starDates = myRepoStars
        view.reloadRepoStars(starDates)
    }
    
    
    // Declare here actions and handlers for events of the View
}
