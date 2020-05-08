//
//  FetchUserInteractor.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 27/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

class FetchUserInteractor {
    private let gitProvider: GitProviderProtocol

    init(gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
    }

    func authenticate(for provider: Provider) -> AnyPublisher<GitUser, Error> {
        gitProvider.authenticate(for: provider)
    }

    func logout(for provider: Provider) {
        gitProvider.logout(for: provider)
    }

    func isAuthenticated(for provider: Provider) -> Bool {
        gitProvider.isAuthenticated(for: provider)
    }

}
