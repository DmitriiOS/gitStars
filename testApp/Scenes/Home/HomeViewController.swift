//
//  HomeViewController.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, HomeView, UITableViewDelegate, UITableViewDataSource {

	var presenter: HomePresenter!
    var gitUserData: GitUserData = GitUserData.init(gitLogin: "", gitChosenRepo: "")
    private let kReposCellID = "Cell"
    private var myGitRepos: [MyGitRepo] = []
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
        presenter.viewWillAppear()
    }
    
    // MARK: - Activity Indicator Actions
    
    func activityIndicatorStart() {
        activityIndicator.startAnimating()
        activityIndicator.layer.zPosition = 1
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
    
    func reloadFactsList(_ factNames: [MyGitRepo]) {
        myGitRepos = factNames
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func reloadRepoStars(_ myRepoStars: [RepoStarsByDates]) {
        self.myRepoStars = myRepoStars
        datesAndStars = presenter.starDatesService.dateOptimizer(myRepoStars)
        
//        let realm = try! Realm()
        
//        let repositories = myGitRepos.map(GithubRepository.init)
// 
//        githubLogin = GithubLogin(gitLogin: gitUserData.gitLogin, repositories: repositories)
//            realmGithubLogin = RealmGithubLogin(model: githubLogin)
//        
//        commitToRealm(object: realmGithubLogin)
        
        
        
//        for i in 0..<myGitRepos.count {
//            githubRepository = GithubRepository(repo: myGitRepos[i])
////            let realm = try! Realm()
//            try! realm.write {
//                let repositories = RealmGithubRepository(model: githubRepository)
//                realm.create(RealmGithubRepository.self, value: repositories, update: .all)
//                realmGithubLogin.repositories.append(realmGithubRepository)
//            }
//
//            let githubRepository = realm.objects(RealmGithubRepository.self)
//            let realmGithubRepository = githubRepository[chosenRepoIndex]
//
//            for i in 0..<myRepoStars.count {
//                githubStarDates = GithubStarDates(starDatesID: myRepoStars[i].user.nodeId, dates: myRepoStars[i].starredAt)
//                try! realm.write {
//                    let realmGithubStarDates = realm.create(RealmGithubStarDates.self, value: ["starDatesID" : githubStarDates.starDatesID, "dates" : githubStarDates.dates], update: .all)
//                    realmGithubRepository.starDates.append(realmGithubStarDates)
//                }
//            }
//            commitToRealm(object: realmGithubLogin)
//        }
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        tableView.isHidden = false
        gitUserData.gitLogin = textField.text ?? ""
        tableView.reloadData()
        presenter.onTextTyped(messageTyped: gitUserData.gitLogin)
        presenter.reloadRepos()
    }
    
    // MARK: - commitToRealm func
    
//    func commitToRealm(object: Object) {
//        do {
//            let realm = try Realm()
//            print("ПУТЬ К БАЗЕ: \(String(describing: realm.configuration.fileURL))")
//            realm.beginWrite()
//            realm.add(object, update: .all)
//            try realm.commitWrite()
//        } catch {
//            print(error)
//        }
//    }
    
    
    
    // MARK: - UITableViewDataSource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myGitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReposCellID) ?? UITableViewCell(style: .default, reuseIdentifier: kReposCellID)
        let repo = myGitRepos[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = "Количество звезд: \(repo.stargazersCount)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicatorStart()
        gitUserData.gitChosenRepo = myGitRepos[indexPath.row].name
        chosenRepoIndex = indexPath.row
        presenter.onRepositoryChosen(chosenLogin: gitUserData.gitLogin, chosenRepo: gitUserData.gitChosenRepo)
        presenter.reloadStarDates()
        activityIndicatorStop()
    }
    
    func whenAllDataIsReady() {
        print("ВСЕ ГОТОВО: \(datesAndStars.count)")
        presenter.onRepoSelected(receivedDatesAndStars: datesAndStars, gitRepoEntered: gitUserData.gitChosenRepo, gitLoginEntered: gitUserData.gitLogin)
    }
}
