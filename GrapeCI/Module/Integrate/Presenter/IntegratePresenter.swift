//
//  IntegratePresenter.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 06/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

class IntegratePresenter: IntegratePresenterProtocol {
    private let integrateInterator: IntegrateInteractorProtocol
    private var repository: GitRepository

    var title: String {
       "Integration for: " + repository.name
    }

    var pipeline: String {
        repository.pipeline ?? ""
    }

    var buttonTitle: String {
       "Save"
    }

    var deIntegrateButtonTitle: String {
        repository.pipeline == nil ? "Cancel" : "DeIntegrate"
    }

    init(repository: GitRepository, integrateInterator: IntegrateInteractorProtocol) {
        self.repository = repository
        self.integrateInterator = integrateInterator
    }

    func integrate(pipeline: String,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void) {
        if pipeline != repository.pipeline {
            repository.pipeline = pipeline
            integrateInterator.integrate(
                repository: repository,
                progress: { log in
                    DispatchQueue.main.async {
                        progress(log)
                    }},
                completion: { resutl in
                    DispatchQueue.main.async {
                        completion(resutl)
                    }
            })
        } else {
            completion(ShellResult(output: "", status: 0))
        }
    }

    func deIntegrate() {
        integrateInterator.deIntegrate(repository: repository)
    }

}
