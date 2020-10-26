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
    private var myGitRepos: [MyGitRepos] = []
    var datesAndStars: [DatesAndStars] = []
    private var myRepoStars: [RepoStarsByDates] = []
   
    var realmGithubLogin = RealmGithubLogin()
    var realmGithubRepository = RealmGithubRepository()
    var realmGithubStarDates = RealmGithubStarDates()
    var githubLogin: GithubLogin!
    var githubRepository: GithubRepository!
    var githubStarDates: GithubStarDates!
    
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
    
    func reloadFactsList(_ factNames: [MyGitRepos]) {
        myGitRepos = factNames
        tableView.reloadData()
        
    }
    
    // MARK: - Actions
    
    func reloadRepoStars(_ myRepoStars: [RepoStarsByDates]) {
        self.myRepoStars = myRepoStars
        
        datesAndStars = presenter.starDatesService.dateOptimizer(myRepoStars)
        activityIndicatorStop()
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        tableView.isHidden = false
        gitUserData.gitLogin = textField.text ?? ""
        tableView.reloadData()
        presenter.onTextTyped(messageTyped: gitUserData.gitLogin)
        presenter.reloadRepos()
        
        githubLogin = GithubLogin(gitLogin: gitUserData.gitLogin)
        realmGithubLogin = RealmGithubLogin(value: ["gitLogin" : githubLogin.gitLogin])
    }
    
    func commitToRealm(object: Object) {
        do {
            let realm = try Realm()
            print("ПУТЬ К БАЗЕ: \(String(describing: realm.configuration.fileURL))")
            realm.beginWrite()
            realm.add(object, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    
    
    // MARK: - UITableViewDataSource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myGitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReposCellID) ?? UITableViewCell(style: .default, reuseIdentifier: kReposCellID)
        let repo = myGitRepos[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = "Количество звезд: \(repo.stargazersCount)"
        
        githubRepository = GithubRepository(repo: repo)
        let realm = try! Realm()
        try! realm.write {
            let repository = RealmGithubRepository(model: githubRepository)
            realm.create(RealmGithubRepository.self, value: repository, update: .all)
            realmGithubLogin.repository.append(realmGithubRepository)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicatorStart()
        gitUserData.gitChosenRepo = myGitRepos[indexPath.row].name
        
        presenter.onRepositoryChosen(chosenLogin: gitUserData.gitLogin, chosenRepo: gitUserData.gitChosenRepo)
        
        print("ГИТ ЛОГИН: \(gitUserData.gitLogin)")
        print("ГИТ РЕПОЗИТОРИЙ: \(gitUserData.gitChosenRepo)")
        
        let realm = try! Realm()
        let githubRepository = realm.objects(RealmGithubRepository.self)
        var realmGithubRepository = githubRepository[indexPath.row]
//        for i in 0..<myGitRepos.count {
//            githubStarDates = GithubStarDates(starDatesID: myGitRepos[i].nodeId, dates: myGitRepos[i].)
//            try! realm.write {
//                let realmGithubStarDates = realm.create(RealmGithubStarDates.self, value: ["starDatesID" : githubStarDates.starDatesID, "dates" : githubStarDates.dates], update: .all)
//                realmGithubRepository.starDates.append(realmGithubStarDates)
//            }
//        }
        
        commitToRealm(object: realmGithubLogin)
        presenter.onRepoSelected(atIndex: indexPath.row, gitLoginEntered: textField.text!)
    }
    
    
}
