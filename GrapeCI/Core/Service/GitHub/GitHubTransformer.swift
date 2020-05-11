//
//  GitHubTransformer.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

extension GitHub {

    func transform(for repositories: GitHubPaginated<GitHubRepository>) -> [GitRepository] {
        var total: [GitRepository] = []

        repositories.items.forEach { repository in
            total.append(transform(for: repository))
        }

        return total
    }

    func transform(for repository: GitHubRepository) -> GitRepository {
        GitRepository(identifier: String(repository.identifier),
                      name: repository.name,
                      fullName: repository.fullName,
                      provider: .gitHub,
                      defaultBranch: GitBranch(name: repository.defaultBranch),
                      url: repository.htmlUrl)
    }

    func transform(for pullRequests: [GitHubPullRequest]) -> [GitPullRequest] {
        pullRequests.map {
            GitPullRequest(identifier: String($0.identifier),
                           title: $0.title,
                           number: $0.number,
                           origin: GitBranch(name: $0.head.ref, lastCommit: GitCommit(sha: $0.head.sha)) ,
                           destination: GitBranch(name: $0.base.ref, lastCommit: GitCommit(sha: $0.base.sha)),
                           link: $0.links.html.href)
        }
    }

    func transform(for commit: GitHubCommit) -> GitCommit {
        GitCommit(sha: commit.sha, builds: [])
    }

    func transform(for builds: [GitHubBuild]) -> [GitBuild] {
        builds.map { transform(for: $0) }
    }

    func transform(for build: GitHubBuild) -> GitBuild {
        GitBuild(state: GitBuildState(rawValue: build.state),
                 key: String(build.identifier ?? 0),
                 name: build.context,
                 buildDescription: build.buildDescription,
                 url: build.url,
                 log: nil)
    }

}
