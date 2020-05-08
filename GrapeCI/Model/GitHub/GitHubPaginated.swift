//
//  GitHubPaginated.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 29/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubPaginated<T>: Decodable where T: Decodable {
    let total: Int
    let isIncomplete: Bool
    let items: [T]

    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case isIncomplete = "incomplete_results"
        case items
    }

}
