//
//  BitBucketAdapter.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

extension BitBucket: GitProviderAdapter {

    func repositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        repositories(nameFilter: nameFilter)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

    func repository(identifier: String, workspaceID: String?) -> AnyPublisher<GitRepository, Error> {
        repository(identifier: identifier, workspaceID: workspaceID)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

    func pullRequests(repository: GitRepository) -> AnyPublisher<[GitPullRequest], Error> {
        pullRequests(repository: repository)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

    func lastCommit(repository: GitRepository, branchName: String) -> AnyPublisher<GitCommit, Error> {
        lastCommit(repository: repository, branchName: branchName)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

    func builds(repository: GitRepository, commit: String) -> AnyPublisher<[GitBuild], Error> {
        builds(repository: repository, commit: commit)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<GitBuild, Error> {
        createBuild(repository: repository, commit: commit, state: state)
            .map(transform(for:))
            .eraseToAnyPublisher()
    }

}
