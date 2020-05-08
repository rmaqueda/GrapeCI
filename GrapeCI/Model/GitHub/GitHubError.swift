//
//  GitHubError.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 05/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubErrors: Codable {
    let message: String
    let errors: [GitHubError]?
    let documentationURL: String?

    enum CodingKeys: String, CodingKey {
        case message
        case errors
        case documentationURL = "documentation_url"
    }
}

struct GitHubError: Codable {
    let resource: String
    let field: String
    let code: String

    enum CodingKeys: String, CodingKey {
        case resource
        case field
        case code
    }
}
