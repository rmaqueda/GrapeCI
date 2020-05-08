//
//  BitBucketBuild.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketBuild: Codable {
    let key: String
    let state: String
    let name: String
    let buildDescription: String
    let url: String
//    let repository: Repository
//    let links: BitBucketBuildLinks
//    let refname: JSONNull?
//    let createdOn: String?
//    let commit: BitBucketBuildCommit
//    let updatedOn: String?
//    let type: String?

    enum CodingKeys: String, CodingKey {
        case key
        case buildDescription = "description"
        case url
        case state
        case name
//        case repository = "repository"
//        case links = "links"
//        case refname = "refname"
//        case createdOn = "created_on"
//        case commit = "commit"
//        case updatedOn = "updated_on"
//        case type
    }

}
