//
//  IntegrateInteractor.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 06/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

class IntegrateInteractor: IntegrateInteractorProtocol {
    private var gitProvider: GitProviderProtocol

    init(gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
    }

    func integrate(repository: GitRepository,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void) {
        gitProvider.integrate(repository: repository,
                              progress: progress,
                              completion: completion)
    }

    func deIntegrate(repository: GitRepository) {
        gitProvider.deIntegrate(repository: repository)
    }

}
