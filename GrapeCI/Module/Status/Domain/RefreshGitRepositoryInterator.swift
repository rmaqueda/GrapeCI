//
//  FetchGitRepositoryInterator.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 22/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

class RefreshGitRepositoryInterator: RefreshGitRepositoryInteratorProtocol {
    private var gitProvider: GitProviderProtocol

    init(gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
    }

    func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error> {
        gitProvider.refreshIntegratedRepositories()
    }

}
