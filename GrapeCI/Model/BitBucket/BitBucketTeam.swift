//
//  GitTeam.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketTeamInfo: Codable {
    let permission: String
    let type: String
    let team: BitBucketTeam

    enum CodingKeys: String, CodingKey {
        case permission
        case type
        case team
    }
}

struct BitBucketTeam: Codable {
    let userName: String
    let displayName: String
    let type: String
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case displayName = "display_name"
        case type
        case uuid
    }
}
