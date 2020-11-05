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
    private let gitService: GitService
    private var gitStarService: GitStarService
    private var repoStarsByDates: [RepoStarsByDates] = []
    var starDatesService: StarDatesService
    private var datesAndStars: [DatesAndStars] = []
    private var repos: [MyGitRepo] = []
    private var receivedGitRepo: String = ""
    private var receivedGitLogin: String = ""
    private let storage: GithubStorage

	// MARK: - Lifecycle

    init(view: HomeView,
         navigator: HomeNavigator,
         gitService: GitService,
         gitStarService: GitStarService,
         starDatesService: StarDatesService,
         storage: GithubStorage

    ){
		self.view = view
		self.navigator = navigator
        self.gitService = gitService
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
        self.storage = storage
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
        // загружаем realm. если таблица GithubLogin содержит message, то загружаем его + его репозитории. + обновляем экран (таблицу)
        if let dataFromRealm = storage.getLogin(by: message) {
            var repos = [MyGitRepo]()
            for i in 0..<dataFromRealm.repositories.count {
                repos.append(MyGitRepo(nodeId: dataFromRealm.repositories[i].repoID,
                                       name: dataFromRealm.repositories[i].repoName,
                                       stargazersCount: dataFromRealm.repositories[i].repoStarsTotal))
            }
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
        repoStarsByDates = []
        //загружаем realm. если таблица GithubRepositories содержит gitChosenRepo, то загружаем его + его даты.
        // ВОПРОС: Если взять даты из БД и перейти на второй экран, то как там подтянуть данные из сети? А если ждать обновления из сети, то какой смысл загружать из БД?
        self.gitStarService.loadRepoDates(login: receivedGitLogin, repoName: receivedGitRepo) { [weak self] in
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
//        self.repoStarsByDates = [RepoStarsByDates]()
        self.repoStarsByDates = dates
        
        saveLogin()
        getRepositoryAndSaveDates()
        view.reloadRepoStars(dates)
    }
    
    func saveLogin() {
        let repositories = repos.map(GithubRepository.init)
        let githubLogin = GithubLogin(gitLogin: gitService.gitLogin, repositories: repositories)
        storage.saveLogin(githubLogin)
    }
    
    func getRepositoryAndSaveDates()  {
//        var nodeID = ""
//        for i in 0..<repos.count {
//            if repos[i].name == receivedGitRepo {
//                nodeID = repos[i].nodeId
//            }
//        }
        guard let nodeID = repos.first(where: { $0.name == receivedGitRepo })?.nodeId else {
            return
        }
        
        let repository = storage.getRepository(by: nodeID)
        
        let starDates = repoStarsByDates.map(GithubStarDates.init)
        
        let githubRepository = GithubRepository(repoID: repository!.repoID, repoName: repository!.repoName, repoStarsTotal: repository!.repoStarsTotal, starDates: starDates)
        storage.saveRepository(githubRepository)
    }

    // Declare here actions and handlers for events of the View
}
