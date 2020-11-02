//
//  GithubStorage.swift
//  testApp
//
//  Created by Dmitriy Orlov on 02.11.2020.
//

import Foundation


protocol GithubStorage {
    func saveLogin(login: GithubLogin)
    func getLogin(by name: String) -> GithubLogin?
    
    func saveRepository(repository: GithubRepository)
    func getRepository(by name: String) -> GithubRepository?
    
    func saveStarDates(starDates: GithubStarDates)
    func getStarDates(by chosenRepo: String) -> GithubStarDates?   
}
