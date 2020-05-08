//
//  GitHubPermissions.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubPermissions: Codable {
    let admin: Bool
    let push: Bool
    let pull: Bool
}
