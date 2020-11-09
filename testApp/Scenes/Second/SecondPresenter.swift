//
//  SecondPresenter.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import  Foundation

protocol GetDataFromHomeVC: AnyObject {
//    func getLoginRepoDatesStars(datesStars: [DatesAndStars], login: String, repository: String)
    func getCurrentRepositoryInfo(currentRepositoryInfo: CurrentRepositoryInfo)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
    func whenAllDataIsReady()
}

protocol SecondView: AnyObject {
    func showReceivedData(repo receivedGitRepo: String, login receivedGitLogin: String)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
}

final class SecondPresenter {

	private unowned var view: GetDataFromHomeVC
	private let navigator: SecondNavigator
    private let currentRepositoryInfo: CurrentRepositoryInfo
    
    private var gitStarService: GitStarService
    var starDatesService: StarDatesService
    private var repoStarsByDates: [RepoStarsByDates] = []
    private var datesAndStars: [DatesAndStars] = []
//    private var datesAndStars: [DatesAndStars] = []
//    private var receivedGitRepo: String
//    private var receivedGitLogin: String

	// MARK: - Lifecycle

    init(view: GetDataFromHomeVC,
         navigator: SecondNavigator,
         currentRepositoryInfo: CurrentRepositoryInfo,
         gitStarService: GitStarService,
         starDatesService: StarDatesService
//         datesAndStars: [DatesAndStars],
//         receivedGitRepo: String,
//         receivedGitLogin: String
    ) {
		self.view = view
		self.navigator = navigator
        self.currentRepositoryInfo = currentRepositoryInfo
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
//        self.datesAndStars = datesAndStars
//        self.receivedGitRepo = receivedGitRepo
//        self.receivedGitLogin = receivedGitLogin

	}


	// MARK: - Actions

    func viewWillAppear() {
        repoStarsByDates = []
        datesAndStars = []
//        view.getLoginRepoDatesStars(datesStars: datesAndStars, login: receivedGitLogin, repository: receivedGitRepo)
        view.getCurrentRepositoryInfo(currentRepositoryInfo: currentRepositoryInfo)
    }
    
    // MARK: - Internal actions
    
    func reloadStarDatesFromDB() {
//        guard let repoId = repositoriesInfo.first(where: { $0.name == receivedGitRepo })?.nodeId else {
//            return
//        }
        if let stars = gitStarService.fetchStarDates(by: currentRepositoryInfo.nodeId) {
            repoStarsByDates = stars.map(RepoStarsByDates.init)
            showRepoStars(repoStarsByDates)
        }
    }
    
    func reloadStarDatesFromAPI() {

//        guard let repoId = repositoriesInfo.first(where: { $0.name == receivedGitRepo })?.nodeId else {
//            return
//        }
        self.gitStarService.loadRepoDates(login: currentRepositoryInfo.owner.login, repoName: currentRepositoryInfo.name, repoId: currentRepositoryInfo.nodeId) { [weak self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let repoStarsByDates):
                DispatchQueue.main.async {
                    self?.showRepoStars(repoStarsByDates)
                }
            }
        }
    }
    
    private func showRepoStars(_ dates: [RepoStarsByDates]) {
        self.repoStarsByDates = dates
        view.reloadRepoStars(dates)
        view.whenAllDataIsReady()
    }
    
    // Declare here actions and handlers for events of the View
}
