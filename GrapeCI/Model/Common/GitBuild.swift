//
//  GitBuild.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitBuild: Equatable {
    let state: GitBuildState
    let key: String
    let name: String
    let buildDescription: String
    let url: String
    var log: String?
}

enum GitBuildState: String {
    case none = "download"
    case inprogress = "inprogress"
    case success = "success"
    case failed = "failure"

    init(rawValue: String) {
        if rawValue == "success" || rawValue == "SUCCESSFUL" {
            self = .success
        } else if rawValue == "inprogress" || rawValue == "INPROGRESS" {
            self = .inprogress
        } else if rawValue == "fail" || rawValue == "FAILED" || rawValue == "failure" {
            self = .failed
        } else {
            self = .none
        }
    }

    var toBitBucket: String {
        switch self {
        case .none:
            return "FAILED"
        case .inprogress:
            return "INPROGRESS"
        case .success:
            return "SUCCESSFUL"
        case .failed:
            return "FAILED"
        }
    }

}
