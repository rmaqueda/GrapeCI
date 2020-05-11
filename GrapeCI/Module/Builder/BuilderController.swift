//
//  Builder.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 20/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Foundation
import Combine

class BuilderController {
    private var pipeline: PipeLine?

    private let gitProvider: GitProviderProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var publisher = PassthroughSubject<Action, Never>()

    enum Action {
        case buildStart(repository: GitRepository)
        case buildFinish(status: GitBuildState)
    }

    init(gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
    }

    func buildIfNeeded(repositories: [GitRepository]) {
        guard pipeline == nil else {
            Swift.print("Work in progress, exit for now.")
            return
        }

        for repository in repositories {
            //TODO: Remove after finish testing integrations.
            guard !repository.fullName.contains("tda") else { continue }

            if let builds = repository.defaultBranch.lastCommit?.builds, buildIsNeeded(builds: builds) {
                runPipeLine(repository: repository)
                break
            }

            for pullRequest in repository.pullRequests {
                if let builds = pullRequest.origin.lastCommit?.builds, buildIsNeeded(builds: builds) {
                    runPipeLine(repository: repository, pullRequest: pullRequest)
                    break
                }
            }
        }
    }

    private func buildIsNeeded(builds: [GitBuild]) -> Bool {
        let success = builds.filter { $0.state == .success || $0.state == .failed }
        return success.count == 0
    }

    private func runPipeLine(repository: GitRepository, pullRequest: GitPullRequest? = nil) {
        publisher.send(.buildStart(repository: repository))

        let oauthString = gitProvider.aouthString(for: repository)
        repository.updateOrigin(authString: oauthString)

        Swift.print(message(repository: repository, pullRequest: pullRequest))
        pipeline = PipeLine(repository: repository, pullRequest: pullRequest)

        pipeline?.run { [weak self] result in
            guard let self = self else { return }
            Swift.print(self.message(repository: repository, pullRequest: pullRequest, result: result))
            self.createBuild(repository: repository, pullRequest: pullRequest, result: result)
        }
    }

    private func message(repository: GitRepository,
                         pullRequest: GitPullRequest? = nil,
                         result: PipeLineResult? = nil) -> String {
        // swiftlint:disable line_length
        var message = "\n#####################################################################################################\n"
        message += "Pipeline \(result == nil ? "started" : "finished") for repository: \(repository.name), "
        if let pullRequest = pullRequest {
            message += "pull request: \(pullRequest.title)\n"
        } else {
            message += "main branch\n"
        }
        if let status = result?.status {
            message += "Status: \(status).\n"
        }
        message += "Directory: \(repository.directory)\n"
        message += "#####################################################################################################\n"
        // swiftlint:enable line_length

        return message
    }

    private func createBuild(repository: GitRepository, pullRequest: GitPullRequest? = nil, result: PipeLineResult) {
        var commit: GitCommit
        let buildStatus: GitBuildState = result.status == 0 ? .success : .failed

        if let pullRequest = pullRequest, let lastCommit = pullRequest.origin.lastCommit {
            commit = lastCommit
        } else if let lastCommit = repository.defaultBranch.lastCommit {
            commit = lastCommit
        } else {
            fatalError("Error getting commit to build.")
        }

        gitProvider.createBuild(repository: repository, commit: commit, state: buildStatus)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    guard let self = self else { return }
                    self.pipeline = nil
                    self.publisher.send(.buildFinish(status: buildStatus))
                },
                receiveValue: { [weak self] build in
                    guard let self = self else { return }
                    self.gitProvider.saveBuildLog(buildId: build.key,
                                                  providerName: repository.provider.rawValue,
                                                  log: result.log)
                }
        ).store(in: &subscriptions)
    }

}

extension BuilderController: Publisher {
    typealias Output = BuilderController.Action
    typealias Failure = Never

    func receive<S>(subscriber: S) where
        S: Subscriber, BuilderController.Failure == S.Failure, BuilderController.Output == S.Input {
        publisher.subscribe(subscriber)
    }

}
