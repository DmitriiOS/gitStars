//
//  GithubStorage.swift
//  testApp
//
//  Created by Dmitriy Orlov on 02.11.2020.
//

import Foundation


protocol GithubStorage {
    func saveLogin(_ login: GithubLogin)
    func getLogin(by name: String) -> GithubLogin?
    
    func saveRepository(_ repository: GithubRepository)
    func getRepository(by id: String) -> GithubRepository?
    
    func saveStarDates(starDates: [GithubStarDates], for repoId: String)
    func getStarDates(by repoId: String) -> [GithubStarDates]?
}
