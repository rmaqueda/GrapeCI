//
//  BitBucketError.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 03/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct BitBucketError: Codable {
    let type: String
    let error: BitBucketErrorMessage

    enum CodingKeys: String, CodingKey {
        case type
        case error
    }
}

struct BitBucketErrorMessage: Codable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}
