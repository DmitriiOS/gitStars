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
    
}
