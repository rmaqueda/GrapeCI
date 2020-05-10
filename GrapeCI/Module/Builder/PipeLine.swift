//
//  PipeLine.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 21/12/2019.
//  Copyright © 2019 Ricardo.Maqueda. All rights reserved.
//

import Foundation

struct PipeLineResult {
    let status: Int
    let log: String
}

struct PipeLine {
    private let workingDir: String
    private let repository: GitRepository
    private let pullRequest: GitPullRequest?
    private let shell: ShellCommand

    init(repository: GitRepository, pullRequest: GitPullRequest?) {
        self.repository = repository
        self.pullRequest = pullRequest
        self.workingDir = repository.directory
        self.shell = ShellCommand(workingDir: workingDir)
    }

    func run(completion: @escaping (PipeLineResult) -> Void) {
        let pipeLine = pipeLineReplacingVariables(repository: self.repository,
                                                  pullRequest: self.pullRequest)

        DispatchQueue.global(qos: .unspecified).async {
            do {
                try self.shell.run(command: pipeLine) { result in
                    let result = PipeLineResult(status: result.status, log: result.output)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(PipeLineResult(status: 1, log: error.localizedDescription))
                }
            }
        }
    }

    private func pipeLineReplacingVariables(repository: GitRepository, pullRequest: GitPullRequest?) -> String {
        guard var script = repository.pipeline else { fatalError("Should has a pipeline here") }
        script = script.replacingOccurrences(of: "$REPOSITORY", with: repository.fullName)
        script = script.replacingOccurrences(of: "$MAIN_BRANCH", with: repository.defaultBranch.name)

        guard let pullRequest = pullRequest else {
            return script
        }

        script = script.replacingOccurrences(of: "$PR_BRANCH", with: pullRequest.destination.name)
        script = script.replacingOccurrences(of: "$PR_BASE", with: pullRequest.origin.name)
        script = script.replacingOccurrences(of: "$PR_ID", with: String(pullRequest.number))
        script = script.replacingOccurrences(of: "$PROVIDER", with: repository.provider.rawValue.lowercased())

        return script
    }

}
