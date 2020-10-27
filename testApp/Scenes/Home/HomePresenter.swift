//
//  HomePresenter.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//
import Foundation


protocol HomeView: AnyObject {
    func reloadFactsList(_ factNames: [MyGitRepos])
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
    func whenAllDataIsReady()
}

final class HomePresenter {
    
    private let reloadDispatchGroup = DispatchGroup()
	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private let gitService: GitService
    private var gitStarService: GitStarService
    private var repoStarsByDates: [RepoStarsByDates] = []
    var starDatesService: StarDatesService
    private var datesAndStars: [DatesAndStars] = []
    private var repos: [MyGitRepos] = []
    private var receivedGitRepo: String = ""
    private var receivedGitLogin: String = ""

	// MARK: - Lifecycle

    init(view: HomeView,
         navigator: HomeNavigator,
         gitService: GitService,
         gitStarService: GitStarService,
         starDatesService: StarDatesService

    ){
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
	}


	// MARK: - Actions
    
    func viewWillAppear() {
        showRepos(repos)
        reloadRepos()
    }
    
    func onRepositoryChosen(chosenLogin: String, chosenRepo: String) {
        receivedGitLogin = chosenLogin
        receivedGitRepo = chosenRepo
        gitStarService.getGitRepoData(login: receivedGitLogin, repo: receivedGitRepo)
    }
    
    func onTextTyped(messageTyped: String) {
        let message = messageTyped
        gitService.getGitLogin(login: message)
    }
    
    func onRepoSelected(receivedDatesAndStars: [DatesAndStars], gitRepoEntered: String, gitLoginEntered: String) {
        navigator.toDetails(receivedDatesAndStars: receivedDatesAndStars, ofGitData: gitRepoEntered, gitLogin: gitLoginEntered)
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
    
    private func showRepos(_ repos: [MyGitRepos]) {
        self.repos = repos
        let factNames = repos
        view.reloadFactsList(factNames)
    }
    
    func reloadStarDates() {
        self.gitStarService.loadRepoDates { [weak self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let repoStarsByDates):
                DispatchQueue.main.async {
                    self?.showRepoStars(repoStarsByDates)
                    self?.view.whenAllDataIsReady()
                }
            }
        }
    }
    
    private func showRepoStars(_ dates: [RepoStarsByDates]) {
        self.repoStarsByDates = dates
        let starDates = repoStarsByDates
        view.reloadRepoStars(starDates)
    }

    // Declare here actions and handlers for events of the View
}
