//
//  ShellCommand.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 21/12/2019.
//  Copyright © 2019 Ricardo.Maqueda. All rights reserved.
//

import Foundation
import os

struct ShellResult {
    let output: String
    let status: Int
}

extension Notification.Name {
    static let pipeCommandLog = Notification.Name("pipeCommandLog")
}

class ShellCommand {
    private let workingDir: String
    private let isVerbose: Bool

    private var task: Process!

    init(workingDir: String, isVerbose: Bool = false) {
        self.workingDir = workingDir
        self.isVerbose = isVerbose
    }

    func run(command: String,
             progress: ((String) -> Void)? = nil,
             completion: @escaping ((ShellResult) -> Void)) throws {

        let outputPipe = Pipe()
        outputPipe.fileHandleForReading.readabilityHandler = { fileHandle in
            if let line = String(data: fileHandle.availableData, encoding: .utf8) {
                progress?(line)
            }
        }

        task = Process()
        task.qualityOfService = .default
        task.launchPath = workingDir
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["-c", command]
        task.standardOutput = outputPipe
        task.standardError = outputPipe
        task.currentDirectoryURL = URL(fileURLWithPath: workingDir)
        task.terminationHandler = { proces in
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            let result = ShellResult(output: output, status: Int(proces.terminationStatus))

            completion(result)
        }

        try task.run()
    }

}
