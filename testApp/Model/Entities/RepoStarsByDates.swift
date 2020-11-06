//
//  RepoStarsByDates.swift
//  testApp
//
//  Created by Dmitriy Orlov on 12.10.2020.
//

import Foundation

struct RepoStarsByDates: Decodable {
    var starredAt: String
    var user: User
}

struct User: Decodable {
    var nodeId: String
    
}

extension RepoStarsByDates {
    init(gitStarDates: GithubStarDates) {
        self.starredAt = gitStarDates.dates
        self.user = User(nodeId: gitStarDates.starDatesID)
    }
}
