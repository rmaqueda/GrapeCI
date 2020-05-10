//
//  IntegrateProtocol.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 06/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Cocoa

// sourcery: autoSpy
protocol IntegratePresenterProtocol {
    var title: String { get }
    var pipeline: String { get }
    var buttonTitle: String { get }
    var deIntegrateButtonTitle: String { get }

    func integrate(pipeline: String,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void)
    func deIntegrate()
}

// sourcery: autoSpy
protocol IntegrateInteractorProtocol {
    func integrate(repository: GitRepository,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void)

    func deIntegrate(repository: GitRepository)
}
