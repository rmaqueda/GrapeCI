//
//  ListProtocol.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 01/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Cocoa
import Combine

// sourcery: autoSpy
protocol ListPresenterProtocol {
    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error>
}

// sourcery: autoSpy
protocol FetchGitRepositoriesInteractorProtocol {
    func integratedRepositories() -> [GitRepository]
    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error>
}
