//
//  HomePresenter.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//
import Foundation


protocol HomeView: AnyObject {
    func reloadFactsList(_ factNames: [CurrentRepositoryInfo])
//    func reloadRepoStars(_ starDates: [RepoStarsByDates])
//    func whenAllDataIsReady()
}

final class HomePresenter {
    
    private var repositoriesInfo: [CurrentRepositoryInfo] = []
    private var currentRepositoryInfo = CurrentRepositoryInfo(nodeId: "", name: "", owner: .init(login: ""), stargazersCount: 0)
    
    private let reloadDispatchGroup = DispatchGroup()
	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private var gitService: GitService
//    private var gitStarService: GitStarService
//    private var repoStarsByDates: [RepoStarsByDates] = []
//    var starDatesService: StarDatesService
//    private var datesAndStars: [DatesAndStars] = []

    private var receivedGitRepo: String = ""
    private var receivedGitLogin: String = ""

	// MARK: - Lifecycle

    init(view: HomeView,
         navigator: HomeNavigator,
         gitService: GitService
//         gitStarService: GitStarService,
//         starDatesService: StarDatesService
    ) {
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
//        self.gitStarService = gitStarService
//        self.starDatesService = starDatesService
	}


	// MARK: - Actions
    
    func viewWillAppear() {
        repositoriesInfo = []
//        repoStarsByDates = []
//        datesAndStars = []
        showRepos(repositoriesInfo)
        reloadRepos()
    }
    
//    func onChosenRepositoryByIndex(chosenLogin: String, chosenRepo: String) {
//        receivedGitLogin = chosenLogin
//        receivedGitRepo = chosenRepo
//    }
    
//    func onChosenRepositoryByIndex(index: Int) {
//        currentRepositoryInfo = repositoriesInfo[index]
//    }
    
    func loadRepositoriesFromDB(loginTyped: String) {
        let login = loginTyped
        if let repositories = gitService.fetchRepositories(by: login) {
            repositoriesInfo = repositories.map(CurrentRepositoryInfo.init)
            view.reloadFactsList(repositoriesInfo)
        }
        gitService.updateGitLogin(login: login)
    }
    
    func loadRepositoriesFromAPI(loginTyped: String) {
        let login = loginTyped
        gitService.updateGitLogin(login: login)
    }
    
    func onRepoSelected(currentRepositoryInfo: CurrentRepositoryInfo
//        receivedDatesAndStars: [DatesAndStars], gitRepoEntered: String, gitLoginEntered: String
    ) {

        navigator.toDetails(currentRepositoryInfo: currentRepositoryInfo
//            receivedDatesAndStars: receivedDatesAndStars, ofGitData: gitRepoEntered, gitLogin: gitLoginEntered
        )
    }
    
    // MARK: - Internal actions

    func reloadRepos() {
        self.gitService.loadFacts { [weak self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let myGitRepos):
                DispatchQueue.main.async {
                    self?.showRepos(myGitRepos)
                }
            }
        }
    }
    
    private func showRepos(_ repos: [CurrentRepositoryInfo]) {
        self.repositoriesInfo = repos
        view.reloadFactsList(repos)
    }
    
//    func reloadStarDatesFromDB() {
//        guard let repoId = repositoriesInfo.first(where: { $0.name == receivedGitRepo })?.nodeId else {
//            return
//        }
//        if let stars = gitStarService.fetchStarDates(by: repoId) {
//            repoStarsByDates = stars.map(RepoStarsByDates.init)
//            showRepoStars(repoStarsByDates)
//        }
//    }
//
//    func reloadStarDatesFromAPI() {
//
//        guard let repoId = repositoriesInfo.first(where: { $0.name == receivedGitRepo })?.nodeId else {
//            return
//        }
//        self.gitStarService.loadRepoDates(login: receivedGitLogin, repoName: receivedGitRepo, repoId: repoId) { [weak self] in
//            switch $0 {
//            case .failure(_):
//                break
//            case .success(let repoStarsByDates):
//                DispatchQueue.main.async {
//                    self?.showRepoStars(repoStarsByDates)
//                }
//            }
//        }
//    }
//
//    private func showRepoStars(_ dates: [RepoStarsByDates]) {
//        self.repoStarsByDates = dates
//        view.reloadRepoStars(dates)
//        view.whenAllDataIsReady()
//    }

    // Declare here actions and handlers for events of the View
}
