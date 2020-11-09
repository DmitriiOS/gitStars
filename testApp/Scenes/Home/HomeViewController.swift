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
    var gitUserData: GitUserData = GitUserData.init(gitLogin: "", gitChosenRepo: "")
    private let kReposCellID = "Cell"
    
    private var repositoriesInfo: [CurrentRepositoryInfo] = []
    private var currentRepositoryInfo = CurrentRepositoryInfo(nodeId: "", name: "", owner: .init(login: ""), stargazersCount: 0)
    
    var datesAndStars: [DatesAndStars] = []
    private var myRepoStars: [RepoStarsByDates] = []
    var realmGithubLogin = RealmGithubLogin()
    var realmGithubRepository = RealmGithubRepository()
    var realmGithubStarDates = RealmGithubStarDates()
    var githubLogin: GithubLogin!
    var githubRepository: GithubRepository!
    var githubStarDates: GithubStarDates!
    var chosenRepoIndex = 0
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "github"
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repositoriesInfo = []
        datesAndStars = []
        myRepoStars = []
        presenter.viewWillAppear()
    }
    
    // MARK: - Activity Indicator Actions
    
    func activityIndicatorStart() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        textField.isEnabled = false
        enterButton.isEnabled = false
        tableView.isHidden = true
    }
    
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        textField.isEnabled = true
        enterButton.isEnabled = true
        tableView.isHidden = false
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
//        datesAndStars = presenter.starDatesService.dateOptimizer(myRepoStars)
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        tableView.isHidden = false
        currentRepositoryInfo.owner.login = textField.text ?? ""
        tableView.reloadData()
        presenter.loadRepositoriesFromDB(loginTyped: currentRepositoryInfo.owner.login)
        presenter.loadRepositoriesFromAPI(loginTyped: currentRepositoryInfo.owner.login)
        presenter.reloadRepos()
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
//        activityIndicatorStart()
//        gitUserData.gitChosenRepo = repositoriesInfo[indexPath.row].name
//        chosenRepoIndex = indexPath.row
//        presenter.onChosenRepositoryByIndex(index: indexPath.row)
        currentRepositoryInfo = repositoriesInfo[indexPath.row]
        presenter.onRepoSelected(currentRepositoryInfo: currentRepositoryInfo)
//        presenter.reloadStarDatesFromDB()
//        presenter.reloadStarDatesFromAPI()
//        activityIndicatorStop()
    }
    
//    func whenAllDataIsReady() {
//        print("ВСЕ ГОТОВО: \(datesAndStars.count)")
//        presenter.onRepoSelected(currentRepositoryInfo: <#T##CurrentRepositoryInfo#>)
        
//        presenter.onRepoSelected(currentRepositoryInfo: currentRepositoryInfo
//            receivedDatesAndStars: datesAndStars, gitRepoEntered: gitUserData.gitChosenRepo, gitLoginEntered: gitUserData.gitLogin
//        )
//    }
}
