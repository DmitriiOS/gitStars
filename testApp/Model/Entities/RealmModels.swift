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
    let repositories: [GithubRepository]
}

extension GithubLogin {
    init(object: RealmGithubLogin) {
        self.init(gitLogin: object.gitLogin,
                  repositories: object.repositories.map(GithubRepository.init))
    }
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
    init(repo: MyGitRepo) {
        self.init(repoID: repo.nodeId,
                  repoName: repo.name,
                  repoStarsTotal: repo.stargazersCount,
                  starDates: [])
    }
}

struct GithubStarDates {
    let starDatesID: String
    let dates: String

}

extension GithubStarDates {
    init(object: RealmGithubStarDates) {
        self.init(starDatesID: object.starDatesID,
                  dates: object.dates)
    }
}

extension GithubStarDates {
    init(starDates: RepoStarsByDates) {
        self.init(starDatesID: starDates.user.nodeId,
                  dates: starDates.starredAt)
    }
}


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
    @objc dynamic var repoStarsTotal = 0
    var starDates = List<RealmGithubStarDates>()
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
