//
//  BitBucketUser.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 29/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketUser: GitUser, Codable {
    let username: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case username
        case displayName = "display_name"
    }
}
