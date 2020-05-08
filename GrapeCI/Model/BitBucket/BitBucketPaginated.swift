//
//  Paginated.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 07/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Foundation

struct BitBucketPaginated<T>: Decodable where T: Decodable {
    let pagelen: Int
    let items: [T]
    let page: Int?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case pagelen
        case items = "values"
        case page
        case size
    }

}
