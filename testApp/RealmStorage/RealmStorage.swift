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
}


