//
//  RealmStorage.swift
//  testApp
//
//  Created by Dmitriy Orlov on 02.11.2020.
//

import Foundation
import RealmSwift

struct RealmStorage: GithubStorage {
    
    func saveLogin(login: GithubLogin) {
        let realmGithubLogin = RealmGithubLogin(model: login)
        commitToRealm(object: realmGithubLogin)
    }
    
    func getLogin(by name: String) -> GithubLogin? {
        let realm = try! Realm()
        let object = realm.object(ofType: RealmGithubLogin.self, forPrimaryKey: name)
        return object.map(GithubLogin.init)
    }
    
    func saveRepository(repository: GithubRepository) {
        let realmGithubRepository = RealmGithubRepository(model: repository)
        commitToRealm(object: realmGithubRepository)
    }
    
    func getRepository(by name: String) -> GithubRepository? {
        let realm = try! Realm()
        let object = realm.object(ofType: RealmGithubRepository.self, forPrimaryKey: name)
        return object.map(GithubRepository.init)
    }
    
    func saveStarDates(starDates: GithubStarDates) {
        let realmGithubStarDates = RealmGithubStarDates(model: starDates)
        commitToRealm(object: realmGithubStarDates)
    }
    
    func getStarDates(by chosenRepo: String) -> GithubStarDates? {
        let realm = try! Realm()
        let object = realm.object(ofType: RealmGithubStarDates.self, forPrimaryKey: chosenRepo)
        return object.map(GithubStarDates.init)
    }
   
    func commitToRealm(object: Object) {
        do {
            let realm = try Realm()
            print("ПУТЬ К БАЗЕ: \(String(describing: realm.configuration.fileURL))")
            realm.beginWrite()
//            realm.delete(object)
            realm.add(object, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}


