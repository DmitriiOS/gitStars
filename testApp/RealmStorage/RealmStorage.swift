//
//  RealmStorage.swift
//  testApp
//
//  Created by Dmitriy Orlov on 02.11.2020.
//

import Foundation
import RealmSwift

struct RealmStorage: GithubStorage {
    
    func saveLogin(_ login: GithubLogin) {
        let realmGithubLogin = RealmGithubLogin(model: login)
        commitToRealm(object: realmGithubLogin)
    }
    
    func getLogin(by name: String) -> GithubLogin? {
        let realm = try! Realm()
        let object = realm.object(ofType: RealmGithubLogin.self, forPrimaryKey: name)
        return object.map(GithubLogin.init)
    }
    
    func saveRepository(_ repository: GithubRepository) {
        let realmGithubRepository = RealmGithubRepository(model: repository)
        commitToRealm(object: realmGithubRepository)
    }
    
    func getRepository(by id: String) -> GithubRepository? {
        let realm = try! Realm()
        let object = realm.object(ofType: RealmGithubRepository.self, forPrimaryKey: id)
        return object.map(GithubRepository.init)
    }
    
    func saveStarDates(starDates: [GithubStarDates], for repoId: String) {
        guard var repository = getRepository(by: repoId) else { return }
        repository.starDates = starDates
        saveRepository(repository)
    }
    
    func getStarDates(by repoId: String) -> [GithubStarDates]? {
        getRepository(by: repoId)?.starDates
    }
    
    func commitToRealm(object: Object) {
        do {
            let realm = try Realm()
            print("ПУТЬ К БАЗЕ: \(String(describing: realm.configuration.fileURL))")
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}


