//
//  HomeViewController.swift
//  testApp
//
//  Created by Dmitriy Orlov on 06.10.2020.
//  
//

import UIKit


class HomeViewController: UIViewController, HomeView, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: HomePresenter!
    private let kReposCellID = "Cell"
    private var repositoriesInfo: [CurrentRepositoryInfo] = []
    private var currentRepositoryInfo = CurrentRepositoryInfo(nodeId: "", name: "", owner: .init(login: ""), stargazersCount: 0)
    private var myRepoStars: [RepoStarsByDates] = []
    var realmGithubLogin = RealmGithubLogin()
    var realmGithubRepository = RealmGithubRepository()
    var realmGithubStarDates = RealmGithubStarDates()
    var githubLogin: GithubLogin!
    var githubRepository: GithubRepository!
    var githubStarDates: GithubStarDates!
    var chosenRepoIndex = 0
    var defaultChartLoading = false
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultChartLoading = true
        textField.text = UserSettings.currentLogin
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myRepoStars = []
        presenter.viewWillAppear()
        enterButtonActions()
        if defaultChartLoading && textField.text != "" {
            currentRepositoryInfo = repositoriesInfo[UserSettings.currentRepositoryIndex]
            presenter.onRepoSelected(currentRepositoryInfo: currentRepositoryInfo)
        }
        defaultChartLoading = false
    }
    
    // MARK: - Setup
    
    private func prepareUI() {
        tableView.isHidden = true
        // Customize UI structure appearance
    }
    
    // MARK: - FactsView
    
    func reloadFactsList(_ factNames: [CurrentRepositoryInfo]) {
        repositoriesInfo = factNames
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func reloadRepoStars(_ myRepoStars: [RepoStarsByDates]) {
        self.myRepoStars = myRepoStars
    }
    
    func enterButtonActions() {
        tableView.isHidden = false
        UserSettings.currentLogin = textField.text!
        currentRepositoryInfo.owner.login = textField.text!
        tableView.reloadData()
        presenter.loadRepositoriesFromDB(loginTyped: currentRepositoryInfo.owner.login)
        presenter.loadRepositoriesFromAPI(loginTyped: currentRepositoryInfo.owner.login)
        presenter.reloadRepos()
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        enterButtonActions()
    }
    
    // MARK: - UITableViewDataSource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositoriesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReposCellID) ?? UITableViewCell(style: .default, reuseIdentifier: kReposCellID)
        let repository = repositoriesInfo[indexPath.row]
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = "Количество звезд: \(repository.stargazersCount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserSettings.currentRepositoryIndex = indexPath.row
        currentRepositoryInfo = repositoriesInfo[indexPath.row]
        presenter.onRepoSelected(currentRepositoryInfo: currentRepositoryInfo)
    }
    
}
