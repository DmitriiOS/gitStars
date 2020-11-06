//
//  GitService.swift
//  testApp
//
//  Created by Dmitriy Orlov on 09.10.2020.
//

import Foundation
import ZippyJSON

//protocol GetGitLogin {
//    func updateGitLogin(login: String)
//}

struct GitService {
    
    private let baseUrlString = "https://api.github.com/users/"
    private let gitReposSuffix = "/repos"
    var gitLogin = ""
    private let urlSession = URLSession.shared
    let storage: GithubStorage
    
    mutating func updateGitLogin(login: String) {
        gitLogin = login
    }

    // MARK: - Actions

    func loadFacts(completion: @escaping (Result<[CurrentRepositoryInfo], Error>) -> Void) {
        let url = URL(string: "\(baseUrlString)\(gitLogin)\(gitReposSuffix)")!
        
        var repositoriesInfo = [CurrentRepositoryInfo]()
        

        
        loadFromUrl(url: url) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = ZippyJSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    repositoriesInfo = try decoder.decode([CurrentRepositoryInfo].self, from: data)
                    saveLogin(with: repositoriesInfo)
                    completion(.success(repositoriesInfo))
                } catch {
                    print("Error: \(error)")
                    completion(.failure(CommonError.brokenData(data)))
                }
            }
        }
    }
    
    // MARK: - Internal
    
    func fetchRepositories(by login: String) -> [GithubRepository]? {
        storage.getLogin(by: login)?.repositories
    }
    
    private func saveLogin(with repos: [CurrentRepositoryInfo]) {
        let repositories = repos.map(GithubRepository.init).map(repositoryWithDates)
        let githubLogin = GithubLogin(gitLogin: gitLogin, repositories: repositories)
        storage.saveLogin(githubLogin)
    }
    
    func repositoryWithDates(repository: GithubRepository) -> GithubRepository {
        var repository = repository
        repository.starDates = storage.getStarDates(by: repository.repoID) ?? []
        return repository
    }
    
    private func loadFromUrl(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: url) { (data, _, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(CommonError.noData))
            }
        }.resume()
    }

    // MARK: - Subtypes

    enum CommonError: LocalizedError {
        case noData
        case brokenData(Data)

        var errorDescription: String? {
            switch self {
            case .noData:
                return "No data"
            case .brokenData(let data):
                if let str = String(data: data, encoding: .utf8) {
                    return str
                } else {
                    return "Broken non-string data. Length: \(data.count)"
                }
            }
        }
    }
}
