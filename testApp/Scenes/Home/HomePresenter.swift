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
}

final class HomePresenter {

	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private let gitService: GitService
    private var gitStarService: GitStarService
    private var myRepoStars: [RepoStarsByDates] = []
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
//         myRepoStars: [RepoStarsByDates],
         starDatesService: StarDatesService
//         datesAndStars: [DatesAndStars],
//         repos: [MyGitRepos],
//         receivedGitRepo: String,
//         receivedGitLogin: String
    ){
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
        self.gitStarService = gitStarService
//        self.myRepoStars = myRepoStars
        self.starDatesService = starDatesService
//        self.datesAndStars = datesAndStars
//        self.repos = repos
//        self.receivedGitRepo = receivedGitRepo
//        self.receivedGitLogin = receivedGitLogin
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
        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//                onPathComponentsReceived(login: receivedGitLogin, repo: receivedGitRepo)
//                dispatchGroup.leave()
//        dispatchGroup.notify(queue: .main) {
//                    self.reloadStarDates()
//                }
    }
    
    func onTextTyped(messageTyped: String) {
        let message = messageTyped
        gitService.getGitLogin(login: message)
    }
    
    func onRepoSelected(atIndex repoIndex: Int, gitLoginEntered: String) {
        guard repoIndex < repos.count else { return }
        
        let repo = repos[repoIndex].name
        navigator.toDetails(receivedDatesAndStars: datesAndStars, ofGitData: repo, gitLogin: gitLoginEntered)
    }
    
//    func onPathComponentsReceived(login: String, repo: String) {
//        let receivedLogin = login
//        let receivedRepo = repo
//        gitStarService.getGitRepoData(login: receivedLogin, repo: receivedRepo)
//    }

    
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
