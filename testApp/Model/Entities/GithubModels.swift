//
//  GithubModels.swift
//  testApp
//
//  Created by Dmitriy Orlov on 12.11.2020.
//

import Foundation

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
    let ownerName: String
    let repoStarsTotal: Int
    var starDates: [GithubStarDates]
}

extension GithubRepository {
    init(object: RealmGithubRepository) {
        self.init(repoID: object.repoID,
                  repoName: object.repoName,
                  ownerName: object.ownerName,
                  repoStarsTotal: object.repoStarsTotal,
                  starDates: object.starDates.map(GithubStarDates.init))
    }
}

extension GithubRepository {
    init(repo: CurrentRepositoryInfo) {
        self.init(repoID: repo.nodeId,
                  repoName: repo.name,
                  ownerName: repo.owner.login,
                  repoStarsTotal: repo.stargazersCount,
                  starDates: [])
    }
}

struct GithubStarDates {
    let starDatesID: String
    let date: String
    
}

extension GithubStarDates {
    init(object: RealmGithubStarDates) {
        self.init(starDatesID: object.starDatesID,
                  date: object.date)
    }
}

extension GithubStarDates {
    init(starDates: RepoStarsByDates) {
        self.init(starDatesID: starDates.user.nodeId,
                  date: starDates.starredAt)
    }
}
