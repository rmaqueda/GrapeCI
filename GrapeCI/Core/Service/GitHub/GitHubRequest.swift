//
//  GitHubRequest.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

extension GitHub {

    func repositories(nameFilter: String) -> AnyPublisher<GitHubPaginated<GitHubRepository>, Error> {
        guard let userName = user?.username else {
            return Fail(error: NetworkError.login).eraseToAnyPublisher()
        }

        let url = baseURL.appendingPathComponent("search/repositories")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let query = URLQueryItem(name: "q", value: "\(nameFilter)+in:name+user:\(userName)")
        let pageLen = URLQueryItem(name: "per_page", value: "100")
        components?.queryItems = [query, pageLen]

        let request = oauth2.request(forURL: components!.url!)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: GitHubPaginated<GitHubRepository>.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func repository(identifier: String, workspaceID: String?) -> AnyPublisher<GitHubRepository, Error> {
        let urlString = "/repositories/\(identifier)"
        let url = baseURL.appendingPathComponent(urlString)
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: GitHubRepository.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func pullRequests(repository: GitRepository) -> AnyPublisher<[GitHubPullRequest], Error> {
        let url = baseURL.appendingPathComponent("/repos/\(repository.fullName)/pulls")
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: [GitHubPullRequest].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    func lastCommit(repository: GitRepository, branchName: String) -> AnyPublisher<GitHubCommit, Error> {
        let urlString = "/repos/\(repository.fullName)/commits/\(branchName)"
        let url = baseURL.appendingPathComponent(urlString)
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: GitHubCommit.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    func builds(repository: GitRepository, commit: String) -> AnyPublisher<[GitHubBuild], Error> {
        let urlString = "/repos/\(repository.fullName)/statuses/\(commit)"
        let url = baseURL.appendingPathComponent(urlString)
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: [GitHubBuild].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<GitHubBuild, Error> {
        guard let user = self.user else {
            return Fail(error: NetworkError.login).eraseToAnyPublisher()
        }

        let build = GitHubBuild(identifier: nil,
                                state: state.rawValue,
                                context: "GrapeCI",
                                buildDescription: "Build by " + user.username,
                                url: repository.url)

        let urlString = "/repos/\(repository.fullName)/statuses/\(commit.sha)"

        let url = baseURL.appendingPathComponent(urlString)
        var request = oauth2.request(forURL: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(build)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(GitHubErrors.self, from: data)
                        throw NetworkError.generic(message: error.message)
                    }
                }
                return data
        }
        .decode(type: GitHubBuild.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
