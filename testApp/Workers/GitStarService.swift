//
//  GitStarService.swift
//  testApp
//
//  Created by 1 on 12.10.2020.
//

import Foundation
import ZippyJSON

struct GitStarService {
    
    private let baseRepoUrlString = "https://api.github.com/repos/"
    private let gitRepoSuffix = "/stargazers"
    
    private let reloadDispatchGroup = DispatchGroup()
    
    private let urlSession = URLSession.shared
    
    let storage: GithubStorage
    
    // MARK: - Actions

    func loadRepoDates(login: String, repoName: String, repoId: String, completion: @escaping (Result<[RepoStarsByDates], Error>) -> Void) {
        
        var pageNum = 1
        var repoStarsByDates = [RepoStarsByDates]()
        
        while pageNum < 5 {

            let url = URL(string: "\(baseRepoUrlString)\(login)/\(repoName)\(gitRepoSuffix)?page=\(pageNum)&per_page=100")!

            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.v3.star+json", forHTTPHeaderField: "Accept")

            reloadDispatchGroup.enter()
            
            loadDatesFromUrlRequest(request: request) {
                switch $0 {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
                        let decoder = ZippyJSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let stars = try decoder.decode([RepoStarsByDates].self, from: data)
                        repoStarsByDates.append(contentsOf: stars)
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
        
        storage.saveStarDates(starDates: repoStarsByDates.map(GithubStarDates.init), for: repoId)
        
        completion(.success(repoStarsByDates))
        
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
