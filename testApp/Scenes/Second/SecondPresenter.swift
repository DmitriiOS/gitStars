//
//  SecondPresenter.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import  Foundation

protocol StarsDataProvider: AnyObject {
    func getCurrentRepositoryInfo(currentRepositoryInfo: CurrentRepositoryInfo)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
    func whenAllDataIsReady()
    func activityIndicatorStop()
}

protocol SecondView: AnyObject {
    func showReceivedData(repo receivedGitRepo: String, login receivedGitLogin: String)
    func reloadRepoStars(_ starDates: [RepoStarsByDates])
}

final class SecondPresenter {
    private unowned var dataProvider: StarsDataProvider
    private let navigator: SecondNavigator
    private let currentRepositoryInfo: CurrentRepositoryInfo
    private var gitStarService: GitStarService
    var starDatesService: StarDatesService
    private var repoStarsByDates: [RepoStarsByDates] = []
    
    // MARK: - Lifecycle
    
    init(view: StarsDataProvider,
         navigator: SecondNavigator,
         currentRepositoryInfo: CurrentRepositoryInfo,
         gitStarService: GitStarService,
         starDatesService: StarDatesService) {
        self.dataProvider = view
        self.navigator = navigator
        self.currentRepositoryInfo = currentRepositoryInfo
        self.gitStarService = gitStarService
        self.starDatesService = starDatesService
    }
    
    
    // MARK: - Actions
    
    func viewWillAppear() {
        print("НАЧАЛО ВТОРОГО ЭКРАНА")
        reloadStarDatesFromDB()
        reloadStarDatesFromAPI()
        dataProvider.getCurrentRepositoryInfo(currentRepositoryInfo: currentRepositoryInfo)
    }
    
    // MARK: - Internal actions
    
    func reloadStarDatesFromDB() {
        if let stars = gitStarService.fetchStarDates(by: currentRepositoryInfo.nodeId) {
            repoStarsByDates = stars.map(RepoStarsByDates.init)
            if repoStarsByDates.count > 0 {
                showRepoStars(repoStarsByDates)
            } else {
                reloadStarDatesFromAPI()
            }
        }
    }
    
    func reloadStarDatesFromAPI() {
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
        dataProvider.reloadRepoStars(dates)
        dataProvider.whenAllDataIsReady()
        dataProvider.activityIndicatorStop()
    }
    
    // Declare here actions and handlers for events of the View
}
