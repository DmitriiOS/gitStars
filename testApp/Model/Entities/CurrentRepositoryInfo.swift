//
//  MyGitRepos.swift
//  testApp
//
//  Created by Dmitriy Orlov on 09.10.2020.
//

import Foundation

struct CurrentRepositoryInfo: Decodable {
    var nodeId: String
    var name: String
    var owner: Owner
    var stargazersCount: Int
}

struct Owner: Decodable {
    var login: String
}

extension CurrentRepositoryInfo {
    init(githubRepo: GithubRepository) {
        self.nodeId = githubRepo.repoID
        self.name = githubRepo.repoName
        self.owner = Owner(login: githubRepo.ownerName)
        self.stargazersCount = githubRepo.repoStarsTotal
    }
}
