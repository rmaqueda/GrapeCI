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

    func integrate(repository: GitRepository) {
        gitProvider.integrate(repository: repository)
    }

    func deIntegrate(repository: GitRepository) {
        gitProvider.deIntegrate(repository: repository)
    }

}
