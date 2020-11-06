//
//  MyGitRepos.swift
//  testApp
//
//  Created by Dmitriy Orlov on 09.10.2020.
//

import Foundation

struct MyGitRepo: Decodable {
    var nodeId: String
    var name: String
    var stargazersCount: Int
}

extension MyGitRepo {
    init(githubRepo: GithubRepository) {
        self.nodeId = githubRepo.repoID
        self.name = githubRepo.repoName
        self.stargazersCount = githubRepo.repoStarsTotal
    }
}
