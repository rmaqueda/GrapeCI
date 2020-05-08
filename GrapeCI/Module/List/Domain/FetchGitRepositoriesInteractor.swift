//
//  FetchGitRepositoriesInteractor.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 25/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

class FetchGitRepositoriesInteractor: FetchGitRepositoriesInteractorProtocol {
    private let gitProvider: GitProviderProtocol

    init(gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
    }

    func integratedRepositories() -> [GitRepository] {
        gitProvider.integratedRepositories()
    }

    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        gitProvider.fetchRepositories(nameFilter: nameFilter)
    }

}
