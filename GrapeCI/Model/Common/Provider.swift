//
//  Provider.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

enum Provider: String, Codable {
    case gitHub = "GitHub"
    case bitBucket = "BitBucket"

    var url: String {
        switch self {
        case .gitHub:
            return "github.com"
        case .bitBucket:
            return "bitbucket.org"
        }
    }
}
