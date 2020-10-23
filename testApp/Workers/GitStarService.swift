//
//  GitStarService.swift
//  testApp
//
//  Created by 1 on 12.10.2020.
//

import Foundation

protocol GetGitRepoData {
    func getGitRepoData(login: String, repo: String)
}

final class GitStarService: GetGitRepoData {

    
    private let baseRepoUrlString = "https://api.github.com/repos/"
    private let gitRepoSuffix = "/stargazers"
    
    private let reloadDispatchGroup = DispatchGroup()
    
    var myRepoStars: [RepoStarsByDates] = []
    
    var login = ""
    var repo = ""
    
    func getGitRepoData(login: String, repo: String) {
        self.login = login
        self.repo = repo
    }
    
    private let urlSession = URLSession.shared
    
    // MARK: - Actions

    func loadRepoDates(completion: @escaping (Result<[RepoStarsByDates], Error>) -> Void) {
        
        var pageNum = 1
        
        while pageNum < 5 {
            
            let url = URL(string: "\(baseRepoUrlString)\(login)/\(repo)\(gitRepoSuffix)?page=\(pageNum)&per_page=1000")!

            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.v3.star+json", forHTTPHeaderField: "Accept")

            reloadDispatchGroup.enter()
            
            loadDatesFromUrlRequest(request: request) {
                switch $0 {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
    //                    let str = String(data: data, encoding: .utf8)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let stars = try decoder.decode([RepoStarsByDates].self, from: data)
                        self.myRepoStars.append(contentsOf: stars)
//                        completion(.success(self.myRepoStars))
                        print("Loaded")
                    } catch {
                        print("Error: \(error)")
                        completion(.failure(CommonError.brokenData(data)))
                    }
                    
                    self.reloadDispatchGroup.leave()
                }
            }
            
            reloadDispatchGroup.wait(timeout: .now() + 30.0)
            
            pageNum += 1
            print("Next page \(pageNum)")
        }

        completion(.success(self.myRepoStars))
        
    }
    
    // MARK: - Internal

    private func loadDatesFromUrl(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
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

    private func loadDatesFromUrlRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data {
                let httpResponse = response as! HTTPURLResponse
                print("Next: \(httpResponse.allHeaderFields["Link"])")
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
