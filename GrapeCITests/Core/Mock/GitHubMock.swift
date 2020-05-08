//
//  GitHubMock.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine
@testable import GrapeCI

//class GitHubMock: GitHubProviderProtocol {
//    var user: GitHubUser?
//
//    var repositoriesIsCalled = false
//    var authorizeIsCalled = false
//
//    var result: GitHubPaginated<GitHubRepository>?
//    var error: Error?
//
//    func authorize() {
//        authorizeIsCalled = true
//    }
//
//    func repositories(nameFilter: String) -> AnyPublisher<GitHubPaginated<GitHubRepository>, Error> {
//        repositoriesIsCalled = true
//
//        return Future<GitHubPaginated<GitHubRepository>, Error> { promise in
//            if let result = self.result {
//                promise(.success(result))
//            } else if let error = self.error {
//                promise(.failure(error))
//            }
//        }.eraseToAnyPublisher()
//    }
//
//    func repository(identifier: String) -> AnyPublisher<GitHubRepository, Error> {
//        return Future<GitHubRepository, Error> { promise in
//        //TODO: Implement
//        }.eraseToAnyPublisher()
//    }
//
//}
