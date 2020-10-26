//
//  GitService.swift
//  testApp
//
//  Created by 1 on 09.10.2020.
//

import Foundation

protocol GetGitLogin {
    func getGitLogin(login: String)
}

final class GitService: GetGitLogin {
    
    private let baseUrlString = "https://api.github.com/users/"
    private let gitReposSuffix = "/repos"
    
    var myGitInfo: [MyGitRepos] = []
    
    var gitLogin = ""
    
    func getGitLogin(login: String) {
        gitLogin = login
    }
    
    private let urlSession = URLSession.shared
    

    
    // MARK: - Actions

    func loadFacts(completion: @escaping (Result<[MyGitRepos], Error>) -> Void) {
        let url = URL(string: "\(baseUrlString)\(gitLogin)\(gitReposSuffix)")!
        
        loadFromUrl(url: url) {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.myGitInfo = try decoder.decode([MyGitRepos].self, from: data)
                    completion(.success(self.myGitInfo))
                } catch {
                    print("Error: \(error)")
                    completion(.failure(CommonError.brokenData(data)))
                }
            }
        }
    }
    
    // MARK: - Internal

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