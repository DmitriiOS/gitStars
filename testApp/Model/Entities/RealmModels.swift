//
//  RealmModels.swift
//  testApp
//
//  Created by Dmitriy Orlov on 20.10.2020.
//

import Foundation
import RealmSwift


class RealmGithubLogin: Object {
    @objc dynamic var gitLogin = ""
    let repositories = List<RealmGithubRepository>()
    override class func primaryKey() -> String? {
        return "gitLogin"
    }
}

extension RealmGithubLogin {
    convenience init(model: GithubLogin) {
        self.init()
        gitLogin = model.gitLogin
        repositories.append(objectsIn: model.repositories.map(RealmGithubRepository.init))
    }
}

class RealmGithubRepository: Object {
    @objc dynamic var repoID = ""
    @objc dynamic var repoName = ""
    @objc dynamic var ownerName = ""
    @objc dynamic var repoStarsTotal = 0
    let starDates = List<RealmGithubStarDates>()
    override class func primaryKey() -> String? {
        return "repoID"
    }
}

extension RealmGithubRepository {
    convenience init(model: GithubRepository) {
        self.init()
        repoID = model.repoID
        repoName = model.repoName
        ownerName = model.ownerName
        repoStarsTotal = model.repoStarsTotal
        starDates.append(objectsIn: model.starDates.map(RealmGithubStarDates.init))
    }
}


class RealmGithubStarDates: Object {
    @objc dynamic var starDatesID = ""
    @objc dynamic var date = ""
    override class func primaryKey() -> String? {
        return "starDatesID"
    }
}

extension RealmGithubStarDates {
    convenience init(model: GithubStarDates) {
        self.init()
        starDatesID = model.starDatesID
        date = model.date
    }
}
