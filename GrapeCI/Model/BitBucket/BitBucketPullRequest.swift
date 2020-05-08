//
//  BitBucketPullRequest.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketPullRequest: Decodable {
    let identifier: Int
    let title: String
    let links: Link
    let source: Resource
    let destination: Resource

    struct Link: Decodable {
        let html: HTML
    }

    struct HTML: Decodable {
        let href: String
    }

    struct Resource: Decodable {
        let commit: Commit
        let branch: Branch
    }

    struct Commit: Decodable {
        let hash: String
    }

    struct Branch: Decodable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case links
        case source
        case destination
    }

}
