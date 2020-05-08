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

class ShellCommand {
    private let workingDir: String
    private let isVerbose: Bool

    init(workingDir: String, isVerbose: Bool = false) {
        self.workingDir = workingDir
        self.isVerbose = isVerbose
    }

    func run(command: String) throws -> ShellResult {
        let outputPipe = Pipe()

        let task = Process()
        task.qualityOfService = .default
        task.launchPath = workingDir
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["-c", command]
        task.standardOutput = outputPipe
        task.standardError = outputPipe
        task.currentDirectoryURL = URL(fileURLWithPath: workingDir)
        try task.run()
        task.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)

        return ShellResult(output: output, status: Int(task.terminationStatus))
    }

}
