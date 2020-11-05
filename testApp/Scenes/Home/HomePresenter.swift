//
//  HomePresenter.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//
import Foundation


protocol HomeView: AnyObject {
    func reloadFactsList(_ factNames: [MyGitRepo])
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
    func whenAllDataIsReady()
}

final class HomePresenter {
    
    private let reloadDispatchGroup = DispatchGroup()
	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private var gitService: GitService
    private var gitStarService: GitStarService
    private var repoStarsByDates: [RepoStarsByDates] = []
    var starDatesService: StarDatesService
    private var datesAndStars: [DatesAndStars] = []
    private var repos: [MyGitRepo] = []
    private var receivedGitRepo: String = ""
    private var receivedGitLogin: String = ""

	// MARK: - Lifecycle

    init(view: HomeView,
         navigator: HomeNavigator,
         gitService: GitService,
         gitStarService: GitStarService,
         starDatesService: StarDatesService)
    {
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
	}


	// MARK: - Actions
    
    func viewWillAppear() {
        repos = []
        repoStarsByDates = []
        datesAndStars = []
        
        showRepos(repos)
        reloadRepos()
    }
    
    func onRepositoryChosen(chosenLogin: String, chosenRepo: String) {
        receivedGitLogin = chosenLogin
        receivedGitRepo = chosenRepo
    }
    
    func onTextTypedAndLoadFromRealm(messageTyped: String) {
        let message = messageTyped
        if let repositories = gitService.fetchRepositories(by: message) {
            let repos = repositories.map(MyGitRepo.init)
            view.reloadFactsList(repos)
        }
        gitService.updateGitLogin(login: message)
    }
    
    func onTextTypedAndLoadFromAPI(messageTyped: String) {
        let message = messageTyped
        gitService.updateGitLogin(login: message)
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
    
    private func showRepos(_ repos: [MyGitRepo]) {
        self.repos = repos
        view.reloadFactsList(repos)
    }
    
    func reloadStarDates() {

        guard let repoId = repos.first(where: { $0.name == receivedGitRepo })?.nodeId else {
            return
        }
        self.gitStarService.loadRepoDates(login: receivedGitLogin, repoName: receivedGitRepo, repoId: repoId) { [weak self] in
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
        view.reloadRepoStars(dates)
    }

    // Declare here actions and handlers for events of the View
}
