//
//  BitBucketCommit.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketCommit: Codable {
//    let rendered: Rendered
    let hash: String
//    let repository: Repository
//    let links: BitBucketComitLinks
//    let author: Author
//    let summary: Summary
//    let parents: [JSONAny]
    let date: String
    let message: String
    let type: String

    enum CodingKeys: String, CodingKey {
//        case rendered = "rendered"
        case hash
//        case repository = "repository"
//        case links = "links"
//        case author = "author"
//        case summary = "summary"
//        case parents = "parents"
        case date
        case message
        case type
    }
}
