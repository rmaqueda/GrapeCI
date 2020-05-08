//
//  BitBucketRequest.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

extension BitBucket {

    func repositories(nameFilter: String) -> AnyPublisher<BitBucketPaginated<BitBucketRepository>, Error> {
        guard let userName = user?.username else {
            return Fail(error: NetworkError.login).eraseToAnyPublisher()
        }

        var publishers = Publishers
            .Sequence<[AnyPublisher<BitBucketPaginated<BitBucketRepository>, Error>], Error>(sequence:

                teams.map { repositories(nameFilter: nameFilter, userName: $0.userName) })
        publishers = publishers.append(repositories(nameFilter: nameFilter, userName: userName))

        return publishers
            .flatMap { $0 }
            .collect()
            .map {
                var total: [BitBucketRepository]  = []
                $0.forEach { total.append(contentsOf: $0.items) }
                return BitBucketPaginated<BitBucketRepository>(pagelen: 1, items: total, page: 1, size: total.count)
        }
        .eraseToAnyPublisher()
    }

    private func repositories(nameFilter: String,
                              userName: String) -> AnyPublisher<BitBucketPaginated<BitBucketRepository>, Error> {
        let url = baseURL.appendingPathComponent("/2.0/repositories/\(userName)")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let pageLen = URLQueryItem(name: "pagelen", value: "100")
        components?.queryItems = [pageLen]

        let filter = URLQueryItem(name: "q", value: "name~\"\(nameFilter)\"")
        components?.queryItems?.append(filter)

        let request = oauth2.request(forURL: components!.url!)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(BitBucketError.self, from: data)
                        throw NetworkError.generic(message: error.error.message)
                    }
                }
                return data
        }
        .decode(type: BitBucketPaginated<BitBucketRepository>.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func repository(identifier: String, workspaceID: String?) -> AnyPublisher<BitBucketRepository, Error> {
        let url = baseURL.appendingPathComponent("/2.0/repositories/" + workspaceID! + "/" + identifier)
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(BitBucketError.self, from: data)
                        throw NetworkError.generic(message: error.error.message)
                    }
                }
                return data
        }
        .decode(type: BitBucketRepository.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func pullRequests(repository: GitRepository) -> AnyPublisher<BitBucketPaginated<BitBucketPullRequest>, Error> {
        let url = baseURL.appendingPathComponent("/2.0/repositories/\(repository.fullName)/pullrequests")
        let request = oauth2.request(forURL: url)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(BitBucketError.self, from: data)
                        throw NetworkError.generic(message: error.error.message)
                    }
                }
                return data
        }
        .decode(type: BitBucketPaginated<BitBucketPullRequest>.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func lastCommit(repository: GitRepository,
                    branchName: String) -> AnyPublisher<BitBucketPaginated<BitBucketCommit>, Error> {
        let urlString = "/2.0/repositories/\(repository.fullName)/commits/\(branchName)"
        let url = baseURL.appendingPathComponent(urlString)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let pageLen = URLQueryItem(name: "pagelen", value: "1")
        components?.queryItems = [pageLen]

        let request = oauth2.request(forURL: components!.url!)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(BitBucketError.self, from: data)
                        throw NetworkError.generic(message: error.error.message)
                    }
                }
                return data
        }
        .decode(type: BitBucketPaginated<BitBucketCommit>.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func builds(repository: GitRepository, commit: String) -> AnyPublisher<BitBucketPaginated<BitBucketBuild>, Error> {
        let urlString = "/2.0/repositories/\(repository.fullName)/commit/\(commit)/statuses"
        let url = baseURL.appendingPathComponent(urlString)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let pageLen = URLQueryItem(name: "pagelen", value: "100")
        components?.queryItems = [pageLen]
        let request = oauth2.request(forURL: components!.url!)

        return perform(request: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    do {
                        let error = try JSONDecoder().decode(BitBucketError.self, from: data)
                        throw NetworkError.generic(message: error.error.message)
                    }
                }
                return data
        }
        .decode(type: BitBucketPaginated<BitBucketBuild>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<BitBucketBuild, Error> {
        guard let user = self.user else {
            return Fail(error: NetworkError.login).eraseToAnyPublisher()
        }

        let key = "GR-" + user.username
        let description = "Build by " + user.username
        let name = "GrapeCI"

        let build = BitBucketBuild(key: key,
                                   state: state.toBitBucket,
                                   name: name,
                                   buildDescription: description,
                                   url: repository.url)

        let path = "/2.0/repositories/\(repository.fullName)/commit/\(commit.sha)/statuses/build"
        let url = baseURL.appendingPathComponent(path)
        var request = oauth2.request(forURL: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
        .decode(type: BitBucketBuild.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

}
