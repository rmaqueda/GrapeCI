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
    private var task: Process!
    private var log = ""

    init(workingDir: String, isVerbose: Bool = false) {
        self.workingDir = workingDir
        self.isVerbose = isVerbose
    }

    func run(command: String,
             progress: ((String) -> Void)? = nil,
             completion: @escaping ((ShellResult) -> Void)) throws {

        let outputPipe = Pipe()
        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let self = self else { return }
            if let line = String(data: fileHandle.availableData, encoding: .utf8) {
                progress?(line)
                 #if DEBUG
                print(line.replacingOccurrences(of: "\n", with: ""))
                #endif
                self.log += line
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
        task.terminationHandler = { [weak self] proces in
            guard let self = self else { return }
            let result = ShellResult(output: self.log, status: Int(proces.terminationStatus))
            completion(result)
        }

        try task.run()
    }

}
