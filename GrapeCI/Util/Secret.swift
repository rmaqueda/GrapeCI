//
//  Secret.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

enum Secrets {

    enum GitHub {
        static let clientId = Secrets.environmentVariable(named: "GITHUB_CLIENT_ID")
        static let clientSecret = Secrets.environmentVariable(named: "GITHUB_CLIENT_SECRET")
    }

    enum BitBucket {
        static let clientId = Secrets.environmentVariable(named: "BITBUCKET_CLIENT_ID")
        static let clientSecret = Secrets.environmentVariable(named: "BITBUCKET_CLIENT_SECRET")
    }

    // See installatin instuctions here: https://github.com/rmaqueda/GrapeCI#how-to-install
    fileprivate static func environmentVariable(named: String) -> String {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[named], value.count > 0 else {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                return ""
            } else {
                fatalError("‼️ Missing Environment Variable: '\(named)'")
            }
        }

        return value
    }

}
