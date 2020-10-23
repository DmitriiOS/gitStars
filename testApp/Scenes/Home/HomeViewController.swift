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
    var gitData: GitUserData = GitUserData.init(gitLogin: "", gitChosenRepo: "")
    private let kReposCellID = "Cell"
    private var myGitInfo: [MyGitRepos] = []
   
    var realmGithubRepository = RealmGithubRepository()
    var realmGithubLogin = RealmGithubLogin()
    var githubLogin: GithubLogin!
    var githubRepository: GithubRepository!
    var githubStarDates: GithubStarDates!
    
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
        
    // MARK: - Setup
    
    private func prepareUI() {
        // Customize UI structure appearance
    }
    
    // MARK: - FactsView
    
    func reloadFactsList(_ factNames: [MyGitRepos]) {
        myGitInfo = factNames
        tableView.reloadData()
        
    }
    
    // MARK: - Actions
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        gitData.gitLogin = textField.text ?? ""
        tableView.reloadData()
        presenter.onTextTyped(messageTyped: gitData.gitLogin)
        presenter.reloadRepos()
        
        githubLogin = GithubLogin(gitLogin: gitData.gitLogin)
        realmGithubLogin = RealmGithubLogin(value: ["gitLogin" : githubLogin.gitLogin])
//        commitToRealm(object: realmGithubLogin)
     
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
        myGitInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReposCellID) ?? UITableViewCell(style: .default, reuseIdentifier: kReposCellID)
        let repo = myGitInfo[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = "Количество звезд: \(repo.stargazersCount)"
        
//        do {
//            let realm = try Realm()
//            let realmGithubLogin = realm.objects(RealmGithubLogin.self)
//        } catch {
//            print(error)
//        }
        
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
        
        let realm = try! Realm()
        let githubRepository = realm.objects(RealmGithubRepository.self)
        var realmGithubRepository = githubRepository[indexPath.row]
    
    
        
        for i in 0..<myGitInfo.count {
            githubStarDates = GithubStarDates(starDatesID: myGitInfo[i].nodeId, dates: myGitInfo[i].)

            try! realm.write {
                let realmGithubStarDates = realm.create(RealmGithubStarDates.self, value: ["starDatesID" : githubStarDates.starDatesID, "dates" : githubStarDates.dates], update: .all)
                realmGithubRepository.starDates.append(realmGithubStarDates)
            }
        }
//            commitToRealm(object: realmGithubRepository)

        
        commitToRealm(object: realmGithubLogin)
        
        presenter.onRepoSelected(atIndex: indexPath.row, gitLoginEntered: textField.text!)
    }
    
}
