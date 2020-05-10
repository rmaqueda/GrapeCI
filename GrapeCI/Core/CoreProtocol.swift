//
//  CoreProtocol.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine
import CoreData
import AppKit

// sourcery: autoSpy
protocol GitProviderProtocol {
    var authenticateView: NSWindow? { get set }
    var providers: [GitProviderAdapter] { get }

    func startMonitoringNetworkChanges()

    func isAuthenticated(for provider: Provider) -> Bool

    func authenticate(for provider: Provider) -> AnyPublisher<GitUser, Error>
    func logout(for provider: Provider)

    func handleOauthRedirectURL(_ url: URL)
    func integratedRepositories() -> [GitRepository]
    func integrate(repository: GitRepository,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void)
    func deIntegrate(repository: GitRepository)

    func aouthString(for repository: GitRepository) -> String

    func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error>
    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error>

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<GitBuild, Error>

    func saveBuildLog(buildId: String, providerName: String, log: String)
}

// sourcery: autoSpy
protocol CoreDataProtocol {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
}

// sourcery: autoSpy
protocol GitProviderAdapter {
    var providerName: Provider { get }
    var user: GitUser? { get }
    var token: String? { get }

    func update()
    func authorize(in window: NSWindow) -> AnyPublisher<GitUser, Error>
    func handleRedirectURL(_ url: URL)
    func logout()

    func repositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error>
    func repository(identifier: String, workspaceID: String?) -> AnyPublisher<GitRepository, Error>
    func pullRequests(repository: GitRepository) -> AnyPublisher<[GitPullRequest], Error>
    func lastCommit(repository: GitRepository, branchName: String) -> AnyPublisher<GitCommit, Error>
    func builds(repository: GitRepository, commit: String) -> AnyPublisher<[GitBuild], Error>

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<GitBuild, Error>
}
