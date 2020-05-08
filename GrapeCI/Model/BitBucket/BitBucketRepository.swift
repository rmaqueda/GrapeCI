//
//  BitBucketRepository.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 29/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketRepository: Codable {
    let uuid: String
    let name: String
    let mainBranch: BitBucketMainBranch?
    let fullName: String
    let owner: Owner
    let links: LinkType

    struct BitBucketMainBranch: Codable {
        let name: String
    }

    struct LinkType: Codable {
        let html: Link
    }

    struct Link: Codable {
        let href: String
    }

    struct Owner: Codable {
        let uuid: String
    }

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case mainBranch
        case fullName = "full_name"
        case owner
        case links
    }

}
