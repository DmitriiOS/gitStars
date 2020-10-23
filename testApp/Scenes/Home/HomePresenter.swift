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
}

final class HomePresenter {

	private unowned var view: HomeView
	private let navigator: HomeNavigator
    private let gitService: GitService
    
    private var repos: [MyGitRepos] = []
    

	// MARK: - Lifecycle

    init(view: HomeView, navigator: HomeNavigator, gitService: GitService) {
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
	}


	// MARK: - Actions
    
    func viewWillAppear() {
        showRepos(repos)
        reloadRepos()
    }
    
    func onTextTyped(messageTyped: String) {
        let message = messageTyped
        gitService.getGitLogin(login: message)
//        navigator.toDetails(ofGitData: , gitLogin: <#T##String#>)
      
    }
    
    func onRepoSelected(atIndex repoIndex: Int, gitLoginEntered: String) {
        guard repoIndex < repos.count else { return }
        
        let repo = repos[repoIndex].name
        navigator.toDetails(receivedDatesAndStars: <#T##[DatesAndStars]#>)
//        navigator.toDetails(ofGitData: repo, gitLogin: gitLoginEntered)
    }
    
    

    
    // MARK: - Internal actions

    func reloadRepos() {
        self.gitService.loadFacts { [weak self] in
            switch $0 {
            case .failure(_):
                break
            case .success(let myGitInfo):
                DispatchQueue.main.async {
                    self?.showRepos(myGitInfo)
                }
            }
        }
    }
    
    private func showRepos(_ repos: [MyGitRepos]) {
        self.repos = repos
        
        let factNames = repos
        view.reloadFactsList(factNames)
    }

    // Declare here actions and handlers for events of the View
}
