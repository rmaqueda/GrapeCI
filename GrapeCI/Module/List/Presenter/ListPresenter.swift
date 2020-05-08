//
//  ListPresenter.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 25/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

class ListPresenter: ListPresenterProtocol {
    private let fetchGitRepositoriesInterator: FetchGitRepositoriesInteractorProtocol

    init(fetchGitRepositoriesInterator: FetchGitRepositoriesInteractorProtocol) {
        self.fetchGitRepositoriesInterator = fetchGitRepositoriesInterator
    }

    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        if nameFilter.count < 2 {
            return Just(integrateRepositories())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return fetchGitRepositoriesInterator.fetchRepositories(nameFilter: nameFilter)
                .map(replaceForIntegrated(_:))
                .map(orderRepositories(_:))
                .eraseToAnyPublisher()
        }
    }

    private func integrateRepositories() -> [GitRepository] {
        fetchGitRepositoriesInterator.integratedRepositories()
    }

    /// Order repositories by provider and then by name
    /// - Parameter repositories: An array of repositories
    /// - Returns: Ordered array of repositories
    private func orderRepositories(_ repositories: [GitRepository]) -> [GitRepository] {
        repositories.sorted {
            if $0.provider.rawValue != $1.provider.rawValue {
                return $0.provider.rawValue.lowercased() < $1.provider.rawValue.lowercased()
            } else {
                return $0.name.lowercased() < $1.name.lowercased()
            }
        }
    }

    /// Replace repository by integrated repository equivalent if exist
    /// - Parameter repositories: An array of repositories
    /// - Returns: New array with integrated repositories replaced
    private func replaceForIntegrated(_ repositories: [GitRepository]) -> [GitRepository] {
        let integrated = fetchGitRepositoriesInterator.integratedRepositories()

        return repositories.map { repository in
            integrated.first(where: { $0.identifier == repository.identifier }) ?? repository
        }
    }

}
