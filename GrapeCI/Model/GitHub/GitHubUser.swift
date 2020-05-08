//
//  GitHubUser.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 28/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubUser: GitUser, Codable {
    let username: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case displayName = "name"
    }
}
