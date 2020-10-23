//
//  RepoStarsByDates.swift
//  testApp
//
//  Created by 1 on 12.10.2020.
//

import Foundation

struct RepoStarsByDates: Decodable {
    var starredAt: String
    var user: User
}

struct User: Decodable {
    var nodeId: String
}
