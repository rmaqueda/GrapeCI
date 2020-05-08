//
//  BitBucketTransformer.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

extension BitBucket {

    func transform(for repositories: BitBucketPaginated<BitBucketRepository>) -> [GitRepository] {
        var total: [GitRepository] = []

        repositories.items.forEach { repository in
            total.append(transform(for: repository))
        }

        return total
    }

    func transform(for repository: BitBucketRepository) -> GitRepository {
        GitRepository(identifier: repository.uuid,
                      name: repository.name,
                      fullName: repository.fullName,
                      provider: .bitBucket,
                      defaultBranch: GitBranch(name: repository.mainBranch?.name ?? "master"),
                      url: repository.links.html.href,
                      workspaceID: repository.owner.uuid)
    }

    func transform(for pullRequests: BitBucketPaginated<BitBucketPullRequest>) -> [GitPullRequest] {
        pullRequests.items.map {
            GitPullRequest(identifier: String($0.identifier),
                           title: $0.title,
                           number: $0.identifier,
                           origin: GitBranch(name: $0.source.branch.name,
                                             lastCommit: GitCommit(sha: $0.source.commit.hash)) ,
                           destination: GitBranch(name: $0.destination.branch.name,
                                                  lastCommit: GitCommit(sha: $0.destination.commit.hash)),
                           link: $0.links.html.href)
        }
    }

    func transform(for builds: BitBucketPaginated<BitBucketBuild>) -> [GitBuild] {
        builds.items.map(transform(for:))
    }

    func transform(for build: BitBucketBuild) -> GitBuild {
        GitBuild(state: GitBuildState(rawValue: build.state),
                 key: build.key,
                 name: build.name,
                 buildDescription: build.buildDescription,
                 url: build.url,
                 log: nil)
    }

    func transform(for commit: BitBucketPaginated<BitBucketCommit>) -> GitCommit {
        let lastCommit = commit.items.last!
        return GitCommit(sha: lastCommit.hash, builds: [])
    }

}
