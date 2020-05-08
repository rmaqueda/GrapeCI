//
//  StatusProtocol.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 10/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

// sourcery: autoSpy
protocol StatusPresenterProtocol {
    func refreshIntegratedRepositories() -> AnyPublisher<[StatusViewModel], Error>
}

// sourcery: autoSpy
protocol RefreshGitRepositoryInteratorProtocol {
    func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error>
}
