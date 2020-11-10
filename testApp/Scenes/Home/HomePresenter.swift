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
}

final class HomePresenter {
    
    private var repositoriesInfo: [CurrentRepositoryInfo] = []
    private var currentRepositoryInfo = CurrentRepositoryInfo(nodeId: "", name: "", owner: .init(login: ""), stargazersCount: 0)
    private let reloadDispatchGroup = DispatchGroup()
	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private var gitService: GitService
    private var receivedGitRepo: String = ""
    private var receivedGitLogin: String = ""

	// MARK: - Lifecycle

    init(view: HomeView,
         navigator: HomeNavigator,
         gitService: GitService) {
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
	}

	// MARK: - Actions
    
    func viewWillAppear() {
        repositoriesInfo = []
        showRepos(repositoriesInfo)
        reloadRepos()
    }
    
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
    
    func onRepoSelected(currentRepositoryInfo: CurrentRepositoryInfo) {
        navigator.toDetails(currentRepositoryInfo: currentRepositoryInfo)
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

    // Declare here actions and handlers for events of the View
}
