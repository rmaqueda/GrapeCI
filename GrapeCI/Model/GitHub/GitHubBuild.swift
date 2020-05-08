//
//  GitHubBuild.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 12/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubBuild: Codable {
    let identifier: Int?
    let state: String
    let context: String
    let buildDescription: String
    let url: String
//    let avatarUrl: String
//    let nodeId: String
//    let targetUrl: JSONNull?

//    let createdAt: String
//    let updatedAt: String
//    let creator: Creator

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case state
        case context
        case buildDescription = "description"
        case url
//        case avatarUrl = "avatar_url"
//        case nodeId = "node_id"
//        case targetUrl = "target_url"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case creator = "creator"
    }
}
