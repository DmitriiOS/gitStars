//
//  RealmModels.swift
//  testApp
//
//  Created by Dmitriy Orlov on 20.10.2020.
//

import Foundation
import RealmSwift

struct GithubLogin {
    let gitLogin: String
}

struct GithubRepository {
    let repoID: String
    let repoName: String
    let repoStarsTotal: Int
    let starDates: [GithubStarDates]
}

extension GithubRepository {
    init(object: RealmGithubRepository) {
        self.init(repoID: object.repoID,
                  repoName: object.repoName,
                  repoStarsTotal: object.repoStarsTotal,
                  starDates: object.starDates.map(GithubStarDates.init))
    }
}

extension GithubRepository {
    init(repo: MyGitRepos) {
        self.init(repoID: repo.nodeId,
                  repoName: repo.name,
                  repoStarsTotal: repo.stargazersCount,
                  starDates: [])
    }
}

struct GithubStarDates {
    let starDatesID: String
    let dates: String
//    let stars: Int
}

extension GithubStarDates {
    init(object: RealmGithubStarDates) {
        self.init(starDatesID: object.starDatesID,
                  dates: object.dates)
    }
}


class RealmGithubLogin: Object {
    @objc dynamic var gitLogin = ""
    let repository = List<RealmGithubRepository>()
    override class func primaryKey() -> String? {
        return "gitLogin"
    }
}

class RealmGithubRepository: Object {
    @objc dynamic var repoID = ""
    @objc dynamic var repoName = ""
    @objc dynamic var repoStarsTotal = 0
//    let gitLogin = LinkingObjects(fromType: RealmGithubLogin.self, property: "repository")
    var starDates = List<RealmGithubStarDates>()
//    @objc dynamic var gitLogin: RealmGithubLogin?
    override class func primaryKey() -> String? {
        return "repoID"
    }
}

extension RealmGithubRepository {
    convenience init(model: GithubRepository) {
        self.init()
        repoID = model.repoID
        repoName = model.repoName
        repoStarsTotal = model.repoStarsTotal
        starDates.append(objectsIn: model.starDates.map(RealmGithubStarDates.init))
    }
}


class RealmGithubStarDates: Object {
    @objc dynamic var starDatesID = ""
    @objc dynamic var dates = ""
//    @objc dynamic var stars = 0
    
    override class func primaryKey() -> String? {
        return "starDatesID"
    }
}

extension RealmGithubStarDates {
    convenience init(model: GithubStarDates) {
        self.init()
        starDatesID = model.starDatesID
        dates = model.dates
    }
}
