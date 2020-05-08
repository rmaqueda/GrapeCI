//
//  NetworkError.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case login
    case generic(message: String)
    case unknown
    case empty

    public var errorDescription: String? {
        switch self {
        case .login:
            return NSLocalizedString("You are not logged", comment: "")
        case .generic(let message):
            return NSLocalizedString("Network error. \n\(message)", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        case .empty:
            return NSLocalizedString("Empty response", comment: "")
        }
    }
}
