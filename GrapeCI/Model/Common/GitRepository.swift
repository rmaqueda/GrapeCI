//
//  GitRepository.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

class GitRepository: Equatable {
    let identifier: String
    let name: String
    let fullName: String
    let provider: Provider
    let url: String
    var defaultBranch: GitBranch
    var workspaceID: String?
    var pipeline: String?
    var pullRequests: [GitPullRequest] = []

    var integrated: Bool {
        pipeline != nil
    }

    var directory: String {
        Constants.mainDirectory + "/" + provider.rawValue + "/" + name.replacingOccurrences(of: " ", with: "_")
    }

    static func == (lhs: GitRepository, rhs: GitRepository) -> Bool {
        return lhs.identifier == rhs.identifier &&
            lhs.provider == rhs.provider
    }

    init(identifier: String,
         name: String,
         fullName: String,
         provider: Provider,
         defaultBranch: GitBranch,
         url: String,
         workspaceID: String? = nil,
         pipeline: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.fullName = fullName
        self.provider = provider
        self.defaultBranch = defaultBranch
        self.url = url
        self.workspaceID = workspaceID
        self.pipeline = pipeline
    }

}

extension GitRepository {

    func clone(authString: String) {
        if !FileManager.default.fileExists(atPath: Constants.mainDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: Constants.mainDirectory,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("Error creating main directory: \(error).")
            }

        }

        let baseDir = Constants.mainDirectory + "/" + provider.rawValue
        do {
            try deleteRepositoryDir()
            try FileManager.default.createDirectory(atPath: baseDir,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Error creating base directory: \(error).")
        }

        let shell = ShellCommand(workingDir: baseDir, isVerbose: true)
        let command = "git clone --progress https://\(authString)@\(provider.url)/\(fullName).git"

        print("Cloning repository: \(command)")

        let clone = try? shell.run(command: command)
        if clone?.status != 0 {
            try? deleteRepositoryDir()
            fatalError("Error cloning repository.")
        }
    }

    func updateOrigin(authString: String) {
        let shell = ShellCommand(workingDir: directory, isVerbose: true)
        let command = "git remote set-url origin https://\(authString)@\(provider.url)/\(fullName).git"

        let update = try? shell.run(command: command)
        if update?.status != 0 {
            fatalError("Error updating repository origin.")
        }
    }

    private func deleteRepositoryDir() throws {
        if FileManager.default.fileExists(atPath: directory) {
            try FileManager.default.removeItem(atPath: directory)
        }
    }

}
