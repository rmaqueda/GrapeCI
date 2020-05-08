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

    init(repository: GitRepository, pullRequest: GitPullRequest?) {
        self.repository = repository
        self.pullRequest = pullRequest
        self.workingDir = repository.directory
    }

    func run(completion: @escaping (PipeLineResult) -> Void) {
        let pipeLine = pipeLineReplacingVariables(repository: self.repository, pullRequest: self.pullRequest)
        let scriptPath = writeScipt(script: pipeLine)
        let shell = ShellCommand(workingDir: workingDir)

        DispatchQueue.global(qos: .unspecified).async {
            do {
                let result = try shell.run(command: scriptPath)
                DispatchQueue.main.async {
                    let result = PipeLineResult(status: result.status, log: result.output)
                    completion(result)
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

    private func writeScipt(script: String) -> String {
        let scriptPath = workingDir + "/script.sh"
        do {
            if FileManager.default.fileExists(atPath: scriptPath) {
                    try FileManager.default.removeItem(atPath: scriptPath)
            }
            let data = script.data(using: .utf8)
            FileManager.default.createFile(atPath: script, contents: data, attributes: nil)

            return script
        } catch {
            fatalError("Error writing script.")
        }
    }

}
