//
//  StatusPresenter.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 22/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

struct StatusViewModel {
    let status: GitBuildState
    let provider: Provider
    let infoText: String
    let repositoryName: String
    let url: URL?
    let log: String?
}

class StatusPresenter: StatusPresenterProtocol {
    private let refreshGitRepositoryInterator: RefreshGitRepositoryInteratorProtocol

    init(refreshGitRepositoryInterator: RefreshGitRepositoryInteratorProtocol) {
        self.refreshGitRepositoryInterator = refreshGitRepositoryInterator
    }

    func refreshIntegratedRepositories() -> AnyPublisher<[StatusViewModel], Error> {
        refreshGitRepositoryInterator.refreshIntegratedRepositories()
            .map(createViewModels(repositories:))
            .eraseToAnyPublisher()
    }

    private func createViewModels(repositories: [GitRepository]) -> [StatusViewModel] {
        var viewModels: [StatusViewModel] = []

        repositories.forEach { repository in
            viewModels.append(viewModelForDefaultBranch(repository: repository))
            viewModels.append(contentsOf: viewModelsForPullRequests(repository: repository))
        }

        viewModels.sort {
            $0.repositoryName < $1.repositoryName
        }

        return viewModels
    }

    private func viewModelForDefaultBranch(repository: GitRepository) -> StatusViewModel {
        StatusViewModel(status: buildState(for: repository.defaultBranch.lastCommit?.builds),
                        provider: repository.provider,
                        infoText: "Branch: " + repository.defaultBranch.name,
                        repositoryName: repository.name,
                        url: URL(string: repository.url),
                        log: repository.defaultBranch.lastCommit?.builds.last?.log)
    }

    private func viewModelsForPullRequests(repository: GitRepository) -> [StatusViewModel] {
        var viewModels: [StatusViewModel] = []

        repository.pullRequests.forEach { pullRequest in
            if let builds = pullRequest.destination.lastCommit?.builds, builds.count > 0 {
                let viewModel = StatusViewModel(status: buildState(for: builds),
                                                provider: repository.provider,
                                                infoText: "PR: " + pullRequest.title,
                                                repositoryName: repository.name,
                                                url: URL(string: pullRequest.link),
                                                log: pullRequest.destination.lastCommit?.builds.last?.log)
                viewModels.append(viewModel)
            } else {
                let viewModel = StatusViewModel(status: .none,
                                                provider: repository.provider,
                                                infoText: "PR: " + pullRequest.title,
                                                repositoryName: repository.name,
                                                url: URL(string: pullRequest.link),
                                                log: nil)
                viewModels.append(viewModel)
            }
        }

        return viewModels
    }

    private func buildState(for builds: [GitBuild]?) -> GitBuildState {
        guard let builds = builds else { return .none }

        if builds.contains(where: { $0.state == .success }) {
            return .success
        }
        if builds.contains(where: { $0.state == .inprogress}) {
            return .inprogress
        }
        if builds.contains(where: { $0.state == .failed}) {
            return .failed
        }
        return .none
    }

}
